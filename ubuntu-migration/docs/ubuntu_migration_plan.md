# Ubuntu 22.04 Migration Plan
## KV260 Edge AI Pipeline: Custom Model Deployment + KubeEdge + Remote Orchestration

> **Goal**: Replace the custom Yocto/PetaLinux OS build (Phase 2 of `README.md`) with the **stock AMD Kria Ubuntu 22.04 image** as the board's base OS, while preserving — and improving — every capability that matters: custom AI model deployment, KubeEdge cluster membership, and `ninoctl`/socket-server remote orchestration.
>
> **Why now**: AMD is deprecating PetaLinux. The Yocto build pipeline is slow, frequently breaks on missing layers, and produced a real `wic`/`--exclude-path` partition-sizing bug during this project's own rebuild. The stock Ubuntu image is AMD's actively maintained path; `xmutil`, `xlnx-firmware-*`, and the Docker-based app pattern are the future-supported workflow.

---

## Current Architecture (Yocto-based, 5 phases)

```
Dev PC (x86, Ubuntu 24.04, IP: 192.168.123.128)
├── Vivado/Vitis 2022.1 (in Ubuntu 20.04 Docker container)
│   └── Builds: .bit, .xclbin, arch.json  ──────────────────────┐
├── Vitis-AI Docker (xilinx/vitis-ai:2.5)                       │
│   └── Compiles: .xmodel files (face_mask_detection_pt, etc.)  │
├── Yocto/BitBake build environment (kv260-yocto Docker)        │
│   └── Builds: petalinux-image-minimal.wic.gz  ─────────────┐  │
└── ninoctl CLI (Go binary)                                  │  │
                                                             │  │
KV260 Board (ARM64 Cortex-A53, IP: 192.168.123.118)          │  │
├── OS: Custom Yocto/PetaLinux Scarthgap minimal  ◄──────────┘  │
├── FPGA overlay: kv260-vvas-sms (DPU B3136)  ◄─────────────────┘
├── Models: /opt/xilinx/kv260-vvas-sms/models.b3136/
│   ├── face_mask_detection_pt/  (custom compiled .xmodel)
│   └── yolov3_voc_tf/          (custom compiled .xmodel)
├── App: smart_model_select (C/GStreamer/VVAS pipeline)
├── edgecore (KubeEdge edge daemon)
└── Socket servers: app-server.py, xmutil-server.py, vitis-server.py

KubeEdge Master (Proxmox VM, separate machine)
└── cloudcore  →  KV260 joins as Ready node
```

### What worked, what didn't
| Component | Status |
|---|---|
| CSI camera capture (AR1335 + AP1302 → `/dev/video0`) | ✅ Working (per-boot steps required) |
| DPU inference + bounding-box overlay | ✅ Working inside container |
| RTSP streaming to dev PC | ✅ Working (`ffplay rtsp://192.168.123.118:554/test`) |
| KubeEdge `edgecore` + cluster membership | ✅ Working (node joins as Ready) |
| Custom model deployment via slot-symlink | ✅ Working |
| Socket servers + `ninoctl` CLI | ✅ Working |
| Yocto image rebuild (WKS partition fix) | ❌ **Stalled** — `WKS_FULL_PATH` still resolves to vendor file, bitbake-server stale cache |
| `IMAGE_ROOTFS_EXTRA_SPACE` → correct partition size | ❌ **Bug unresolved** — needs `--extra-space=4096M` fix + WKS_FULL_PATH fix first |
| Persistence across reboot | ❌ Not implemented — all steps currently manual |

---

## Target Architecture (Ubuntu 22.04-based)

```
Dev PC (x86, Ubuntu 24.04, IP: 192.168.123.128)       ← NO CHANGE
├── Vivado/Vitis 2022.1 (Ubuntu 20.04 Docker)          ← NO CHANGE
│   └── Builds: .bit, .xclbin, arch.json
├── Vitis-AI Docker (xilinx/vitis-ai:2.5)              ← NO CHANGE
│   └── Compiles: .xmodel files
└── ninoctl CLI (Go binary, cross-compiled ARM64)       ← NO CHANGE

KV260 Board (IP: 192.168.123.118)
├── OS: Stock AMD Kria Ubuntu 22.04 LTS  ◄── REPLACES Yocto build
├── FPGA overlay: xlnx-firmware-kv260-smartcam (apt) OR custom kv260-vvas-sms (SCP'd)
├── XRT/VART runtime: from xilinx/smartcam:2022.1 container (or apt packages)
├── Models: bind-mounted into container from host filesystem
├── App: custom gst-launch-1.0 pipeline inside xilinx/smartcam:2022.1
├── edgecore (KubeEdge — keadm join, same as before)   ← SAME COMMAND, SIMPLER SETUP
└── Socket servers: systemd services (easier on Ubuntu than Yocto minimal)

KubeEdge Master (Proxmox VM)                           ← NO CHANGE
└── cloudcore → KV260 joins as Ready node
```

### What changes, what doesn't

| | Yocto path | Ubuntu 22.04 path |
|---|---|---|
| Phase 1 (Vivado/Vitis build) | Unchanged | Unchanged |
| Phase 2 (OS image build) | `bitbake petalinux-image-minimal` — slow, brittle | **Gone** — flash stock AMD image |
| Phase 3 (Flash + partition) | Flash `.wic.gz` + manual resize, copy `system.dtb` | Flash standard `.img.xz` — no resize, no dtb copy |
| containerd install | Baked into Yocto image via `meta-kubeedge` | `apt install containerd` |
| Phase 4 (SCP artifacts to board) | Unchanged | Unchanged |
| Phase 5 (keadm join) | Unchanged | Unchanged |
| Custom model deploy | Slot-symlink in `/opt/xilinx/...` (Yocto rootfs) | Bind-mount model dir into container OR same slot-symlink on Ubuntu rootfs |
| Socket servers | Python scripts, manual or basic init | Python scripts as **systemd services** — cleaner |
| Persistence | Not implemented | Systemd services auto-start; can add GRUB/udev rules |

---

## Migration Phases

> **Prerequisite**: The board is currently running stock Kria Ubuntu 22.04 with `xlnx-firmware-kv260-smartcam` installed and `xilinx/smartcam:2022.1` confirmed working (face detection over RTSP confirmed from prior session).

---

### Phase 1 — Hardware & AI Overlay Compilation

**Status: Complete. No changes needed.**

This phase runs entirely on your **dev PC**, not the board. Vivado/Vitis and Vitis-AI are x86 tools — they are completely independent of whether the board runs Yocto or Ubuntu.

Your artifacts from prior work still apply:
- `kv260-vvas-sms.bit.bin` + `kv260-vvas-sms.dtbo` + `shell.json` (custom DPU overlay)
- `face_mask_detection_pt/` + `yolov3_voc_tf/` compiled `.xmodel` files
- Kernel JSON configs (`kernel_dpu_*.json`, `kernel_bbox_*.json`, `kernel_preprocessor_*.json`)
- `dpu.xclbin`

If you need to recompile models for a different DPU target in the future, the process is identical (Vitis-AI Docker on dev PC, `compile_modelzoo.sh`).

---

### Phase 2 — Ubuntu Base Board Setup

**Status: Done (you already have Ubuntu 22.04 + smartcam working).**

If starting fresh on a new board:
```bash
# Flash stock Kria Ubuntu 22.04 image to SD card
# Download from: https://ubuntu.com/download/amd-xilinx
# Use balenaEtcher — no manual partition resize needed (Ubuntu image auto-expands rootfs)

# After first boot (login: ubuntu / ubuntu):
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository ppa:xilinx-apps
sudo apt install xlnx-firmware-kv260-smartcam docker.io -y
sudo usermod -aG docker $USER && newgrp docker
```

Verify the board boots, SSH works, and `xmutil listapps` shows `kv260-smartcam` available.

---

> [!CAUTION]
> **Do not edit `boot.scr.uimg` directly.** Kria Ubuntu boots via U-Boot, not GRUB — there is no `/etc/default/grub` to patch. Extracting, editing, and recompiling `boot.scr.uimg` with `mkimage` bricked the boot script twice. `boot.scr.uimg.bak` on the boot partition is the safe recovery copy; only attempt this again with an SD card reader on a second PC on hand.
>
> If `edgecore` fails at Phase 5 with a cgroup-related error, fix the driver mismatch instead of touching bootargs:
> ```bash
> grep -i cgroup /etc/containerd/config.toml
> grep -i cgroup /etc/kubeedge/config/edgecore.yaml
> ```
> Adjust the driver setting (`cgroupfs` vs `systemd`) to match between the two.

---

### Phase 4 — Install containerd + CNI Plugins

**Status: ✅ Done.**

```bash
# Install containerd
sudo apt install -y containerd

# Generate default config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Keep SystemdCgroup = true (default) — correct for cgroup v2 on Ubuntu 22.04
# DO NOT change to false; that's for cgroup v1 only

sudo systemctl restart containerd
sudo systemctl enable containerd

# Install CNI plugins (ARM64)
sudo mkdir -p /opt/cni/bin
wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-arm64-v1.3.0.tgz
sudo tar -xzf cni-plugins-linux-arm64-v1.3.0.tgz -C /opt/cni/bin/
ls /opt/cni/bin/   # verify: should show bridge, flannel, host-local, loopback, etc.

# Create CNI network config — required or keadm join fails with "cni plugin not initialized"
# The binaries alone aren't enough; containerd also needs a config in /etc/cni/net.d/
sudo mkdir -p /etc/cni/net.d
sudo tee /etc/cni/net.d/10-containerd-net.conflist <<EOF
{
  "cniVersion": "1.0.0",
  "name": "containerd-net",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "promiscMode": true,
      "ipam": {
        "type": "host-local",
        "ranges": [[{"subnet": "10.88.0.0/16"}]],
        "routes": [{"dst": "0.0.0.0/0"}]
      }
    },
    {
      "type": "portmap",
      "capabilities": {"portMappings": true}
    }
  ]
}
EOF

sudo systemctl restart containerd
```

> **Note**: During `systemctl restart containerd` you will see `overlayfs: idmapped layers are currently not supported` in the kernel log. This is a harmless warning — the KV260 kernel doesn't support idmapped overlayfs mounts, so containerd falls back to standard overlayfs. The service starts and runs normally (`Active: active (running)`).
>
> **Both `/opt/cni/bin/` and `/etc/cni/net.d/` must exist before `keadm join`** — the binaries alone are not enough. Without a config file in `net.d/`, containerd can't initialize the CNI plugin and `keadm join` fails at the sandbox step.

---

### Phase 5 — KubeEdge `edgecore` Join

**Status: ✅ Done. Node joins as `Ready` (`kubectl get nodes` confirmed).**

#### Install keadm

```bash
wget https://github.com/kubeedge/kubeedge/releases/download/v1.15.0/keadm-v1.15.0-linux-arm64.tar.gz
tar -xzf keadm-v1.15.0-linux-arm64.tar.gz
# Binary is nested two levels deep: .../keadm/keadm — cp the file, not the directory
sudo cp keadm-v1.15.0-linux-arm64/keadm/keadm /usr/local/bin/keadm
sudo chmod +x /usr/local/bin/keadm
keadm version  # verify
```

#### Get join token (run on master VM)

```bash
# Use $HOME/.kube/config — NOT /root/.kube/config (permission denied as non-root)
keadm gettoken --kube-config=$HOME/.kube/config
```

#### Clean up any previous failed join attempt

```bash
# If /etc/kubeedge/ exists from a prior attempt, keadm join will refuse to run:
# "the management directory /etc/kubeedge/ is not clean, please remove it first"
sudo rm -rf /etc/kubeedge/
```

#### Join the cluster

```bash
sudo keadm join \
  --cloudcore-ipport=master.ninox.com:10000 \
  --token=<token-from-master> \
  --cgroupdriver=systemd \
  --edgenode-name=kv260-edge-1
```

Verify on the master:
```bash
kubectl get nodes
# kv260-edge-1 should appear as Ready
```

---

### Phase 6 — Load FPGA Overlay + Deploy Custom Models

This is the core of the custom model deployment. Two approaches — pick one based on your goal.

#### Approach A: Use AMD's prebuilt overlay + custom model mounted into container

Best when you want the fastest path and are OK using AMD's `kv260-smartcam` bitstream (same DPU B3136 arch your models were compiled for).

```bash
# On the board: load AMD's overlay
sudo xmutil unloadapp
sudo xmutil loadapp kv260-smartcam

# On the dev PC: SCP your compiled model and JSON configs to the board
#
# WARNING — scp -r nesting pitfall: if the destination directory already exists,
# `scp -r src/ host:dest/` copies the src directory ITSELF into dest, creating
# dest/src/files instead of dest/files. Avoid by copying contents explicitly.

# 1. Create destination dirs on the board first:
ssh ubuntu@192.168.123.118 "mkdir -p /home/ubuntu/models/face_mask_detection_pt /home/ubuntu/jsons"

# 2. Copy model files into the pre-created dir (no -r, explicit destination):
scp ubuntu-migration/models/face_mask_detection_pt/* ubuntu@192.168.123.118:/home/ubuntu/models/face_mask_detection_pt/

# 3. Copy JSON configs as individual files (avoids directory nesting):
scp ubuntu-migration/jsons/*.json ubuntu@192.168.123.118:/home/ubuntu/jsons/

# 4. Copy xclbin:
scp ubuntu-migration/dpu.xclbin ubuntu@192.168.123.118:/home/ubuntu/

# 5. Verify files landed correctly (not nested inside a subdirectory):
ssh ubuntu@192.168.123.118 "ls /home/ubuntu/jsons/ && ls /home/ubuntu/models/face_mask_detection_pt/"

# Update /etc/vart.conf on the board to point to your xclbin:
sudo bash -c 'cat > /etc/vart.conf << EOF
{
  "target": "dpuczdx8g",
  "xclbin": "/home/ubuntu/dpu.xclbin"
}
EOF'
```

**On the host (before starting the container)** — set up the CSI media pipeline:
```bash
# On Ubuntu, ap1302 is part of the Kria kernel and auto-loads when the overlay is applied.
# NO manual insmod needed — verify it loaded:
lsmod | grep ap1302

# CSI camera is on /dev/media1 (not /dev/media0 — USB webcam takes that)
# CSI capture node is /dev/video2 (USB webcam takes /dev/video0, /dev/video1)
# Verify:
media-ctl -d /dev/media1 -p | grep entity
v4l2-ctl --list-devices
```

Then start the container with models and jsons bind-mounted:
```bash
docker run --privileged --net=host \
  -v /dev:/dev -v /sys:/sys -v /tmp:/tmp -v /run:/run \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx \
  -v /home/ubuntu/models:/models \
  -v /home/ubuntu/jsons:/jsons \
  -it xilinx/smartcam:2022.1 bash
```

Inside the container — configure the media pipeline using `smartcam --mipi` (must pass explicit resolution; default is 4K):
```bash
# smartcam --mipi handles all media-ctl pad format setup internally.
# Manual media-ctl -V commands fail with "Invalid argument" because ap1302 pad2
# format (VYYUYY8_1X24) cannot be set directly on this kernel.
# Run smartcam briefly to configure the pipeline, then kill it — kernel state persists.
smartcam --mipi -t rtsp --width 1920 --height 1080 &
sleep 5
kill %1

# Force the capture device to 1080p NV12 (smartcam leaves it at 3840x2160):
v4l2-ctl -d /dev/video2 --set-fmt-video=width=1920,height=1080,pixelformat=NV12
```

> ⚠️ **BLOCKED — see Known Issues below.** The `gst-launch-1.0 v4l2src device=/dev/video2` pipeline fails with `Buffer pool activation failed` even after the above setup. Root cause not yet resolved.

---

#### Known Issues / Blockers for Phase 6A (CSI + custom VVAS pipeline)

| # | Problem | What we tried | Status |
|---|---|---|---|
| 1 | `insmod /tmp/ap1302.ko` fails — file not found | ap1302 is a built-in kernel module on Ubuntu; auto-loads when overlay applied. No insmod needed. | ✅ Resolved |
| 2 | `media-ctl` without `-d` goes to USB webcam (`/dev/media0`) | Must use `-d /dev/media1` for CSI pipeline | ✅ Resolved |
| 3 | `media-ctl -d /dev/media1 -V '"ap1302.4-003c":2 [fmt:VYYUYY8_1X24/1920x1080]'` → `Invalid argument (22)` | Cannot set ap1302 pad2 format directly on Ubuntu kernel. `smartcam --mipi` handles it internally via GStreamer. | ⚠️ Workaround: use smartcam to configure |
| 4 | CSI capture is `/dev/video2`, not `/dev/video0` | USB webcam takes `/dev/video0`+`/dev/video1`. CSI `isp_vcap_csi` is `/dev/video2`. | ✅ Resolved |
| 5 | `smartcam --mipi` defaults to 3840×2160 (4K) | Must pass `--width 1920 --height 1080` explicitly | ✅ Resolved |
| 6 | ap1302 pad2 stays at `UYVY8_1X16/4208x3120` after smartcam exits | csiss pads correctly set to `VYYUYY8_1X24/1920x1080` while smartcam runs; ap1302 pad2 does not change. State partially resets when smartcam exits. | ⚠️ Partially unresolved |
| 7 | `gst-launch-1.0 v4l2src device=/dev/video2` → `Buffer pool activation failed` | `isp_vcap_csi` uses V4L2 Multiplanar API — standard `v4l2src` may not handle it correctly after smartcam exits. v4l2-ctl format set to 1920x1080 NV12 does not fix it. | ❌ **Root cause unknown — BLOCKED** |
| 8 | JSON `xclbin-location` wrong path | Was `/home/ubuntu/ubuntu-migration/dpu.xclbin`; correct is `/home/ubuntu/dpu.xclbin` | ✅ Fixed via sed |
| 9 | JSON `model-path` wrong path | Was `/usr/share/vitis_ai_library/models/`; correct is `/models/` (bind-mount) | ✅ Fixed via sed |

**Next investigation options (not yet tried):**
- Use `io-mode=dmabuf` instead of `mmap` in v4l2src
- Try `gst-launch-1.0 v4l2src device=/dev/video2 ! video/x-raw,...` with explicit multiplanar caps
- Check if `smartcam --mipi` can be kept running while a second pipeline reads from an intermediate tee or FIFO
- Use the `smart_model_select` binary from `smartapp-modified/` which already has a working MIPI pipeline — modify its model path to point to `face_mask_detection_pt`

On the dev PC:
```bash
ffplay stream.sdp    # reuse existing stream.sdp from prior session
```

#### Approach B: Deploy your custom `kv260-vvas-sms` overlay

**Status: ✅ Overlay loaded and models deployed. Docker pipeline run pending.**

Best when you need the custom DPU bitstream you synthesized in Phase 1 (e.g. for a different DPU config, or to package it alongside future custom kernels).

**Step 1 — Prepare firmware files (on dev PC, from workspace root):**

`ubuntu-migration/overlay/` already contains `kv260-vvas-sms.bit.bin` — no need to run `bootgen` again. You only need to compile the `.dtsi` → `.dtbo` since no pre-built `.dtbo` is included:

```bash
# Install device-tree compiler if not present:
sudo apt install device-tree-compiler -y

cd ubuntu-migration/overlay

# Compile .dtsi → .dtbo:
dtc -@ -I dts -O dtb -o kv260-vvas-sms.dtbo kv260-vvas-sms.dtsi
```

> **Note**: `dtc` will print many warnings about `reg_format`, `avoid_default_addr_size`, etc. These are **harmless** — Xilinx overlay DTS files use non-standard reg formats that the host `dtc` doesn't know about but the Kria kernel accepts fine. The `.dtbo` is generated correctly as long as there are no `[ERROR]` lines.

> **If you ever need to regenerate `.bit.bin`** from the raw `.bit` file: first install `xilinx-bootgen` (`sudo apt install xilinx-bootgen`), create a `.bif` file alongside your `.bit`, then run `bootgen`:
> ```bash
> cat > kv260-vvas-sms.bif << 'EOF'
> all:
> {
>     [destination_device = pl] kv260-vvas-sms.bit
> }
> EOF
> bootgen -arch zynqmp -image kv260-vvas-sms.bif -o kv260-vvas-sms.bit.bin -w on
> ```

**Step 2 — SCP firmware bundle to the board (from workspace root):**

```bash
# Copy to /tmp first (no sudo needed for scp)
scp ubuntu-migration/overlay/kv260-vvas-sms.bit.bin \
    ubuntu-migration/overlay/kv260-vvas-sms.dtbo \
    ubuntu-migration/overlay/shell.json \
    ubuntu@192.168.123.118:/tmp/

# Install into firmware directory with sudo
ssh ubuntu@192.168.123.118 \
  "sudo mkdir -p /lib/firmware/xilinx/kv260-vvas-sms && \
   sudo mv /tmp/kv260-vvas-sms.bit.bin \
           /tmp/kv260-vvas-sms.dtbo \
           /tmp/shell.json \
           /lib/firmware/xilinx/kv260-vvas-sms/"
```

**Step 3 — Load the overlay (on the board):**

```bash
sudo xmutil unloadapp
sudo xmutil loadapp kv260-vvas-sms
# Expected output: "kv260-vvas-sms: loaded to slot 0"
```

**Step 4 — Deploy models (from workspace root on dev PC):**

```bash
# Create destination dirs on the board first (avoids scp -r nesting pitfall)
ssh ubuntu@192.168.123.118 "mkdir -p /tmp/face_mask_detection_pt"
scp ubuntu-migration/models/face_mask_detection_pt/* \
    ubuntu@192.168.123.118:/tmp/face_mask_detection_pt/

# Move to final location with sudo
ssh ubuntu@192.168.123.118 \
  "sudo mkdir -p /opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt && \
   sudo cp /tmp/face_mask_detection_pt/* \
           /opt/xilinx/kv260-vvas-sms/models.b3136/face_mask_detection_pt/"
```

**Step 5 — Fix JSON configs and SCP to board (from workspace root on dev PC):**

```bash
cd ubuntu-migration/jsons

# Fix xclbin path (was wrong: /home/ubuntu/ubuntu-migration/dpu.xclbin)
sed -i 's|/home/ubuntu/ubuntu-migration/dpu.xclbin|/home/ubuntu/dpu.xclbin|g' *.json

# Fix model path (was wrong: /usr/share/vitis_ai_library/models/)
# /models/ is the bind-mount path inside the Docker container
sed -i 's|/usr/share/vitis_ai_library/models/|/models/|g' *.json

# Verify
grep -E "xclbin-location|model-path" *.json

cd ../..

# SCP to board
ssh ubuntu@192.168.123.118 "mkdir -p /home/ubuntu/jsons"
scp ubuntu-migration/jsons/*.json ubuntu@192.168.123.118:/home/ubuntu/jsons/
```

**Step 6 — Run the Docker container with Approach B bind-mounts:**

```bash
docker run --privileged --net=host \
  -v /dev:/dev -v /sys:/sys -v /tmp:/tmp -v /run:/run \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx \
  -v /opt/xilinx/kv260-vvas-sms/models.b3136:/models \
  -v /home/ubuntu/jsons:/jsons \
  -it xilinx/smartcam:2022.1 bash
```

> `model-path` in the JSON is `/models/` — this bind-mount maps the host's `models.b3136/` directory to `/models/` inside the container. The container sees `face_mask_detection_pt` directly under `/models/`.

**Step 7 — One-time fixes inside the container (first run only):**

These are needed because the `xilinx/smartcam:2022.1` container has VVAS libraries installed under the arch-specific path but plugins look in `/usr/lib/` directly, and the VART xclbin resolution falls back to `/usr/lib/dpu.xclbin`:

```bash
# 1. VVAS kernel libraries are at /usr/lib/aarch64-linux-gnu/ but plugins look in /usr/lib/
ln -s /usr/lib/aarch64-linux-gnu/libvvas_xboundingbox.so  /usr/lib/libvvas_xboundingbox.so
ln -s /usr/lib/aarch64-linux-gnu/libvvas_xpreprocessor.so /usr/lib/libvvas_xpreprocessor.so
ln -s /usr/lib/aarch64-linux-gnu/libvvas_xdpuinfer.so     /usr/lib/libvvas_xdpuinfer.so

# 2. VART ignores /etc/vart.conf xclbin path (prints "unknown config: { }") and
#    falls back to /usr/lib/dpu.xclbin — symlink /tmp/dpu.xclbin there:
#    (dpu.xclbin is in /tmp because /tmp is bind-mounted from the host)
ln -s /tmp/dpu.xclbin /usr/lib/dpu.xclbin

# 3. Remove iou_type field from prototxt — added in newer Vitis AI, not known to
#    the older VART in this container:
sed -i '/iou_type/d' /models/face_mask_detection_pt/face_mask_detection_pt.prototxt
```

> Note: these symlinks are lost when the container exits. If you restart the container, re-run this block. For persistence, commit the container to a new image: `docker commit <container-id> kv260-smartcam-patched`.

**Step 8 — Run the inference pipeline (inside the container):**

`v4l2src` cannot capture from `isp_vcap_csi` (V4L2 Multiplanar device) — use `mediasrcbin` instead, pointing at the **media device** (`/dev/media1`), not the video node:

```bash
# Run smartcam briefly to configure the CSI media pipeline pad formats,
# then kill it — kernel state persists:
smartcam --mipi -t rtsp --width 1920 --height 1080 &
sleep 5
kill %1

# Full inference pipeline:
gst-launch-1.0 mediasrcbin media-device=/dev/media1 ! \
  video/x-raw,format=NV12,width=1920,height=1080,framerate=30/1 ! \
  vvas_xinfer \
    preprocess-config=/jsons/kernel_preprocessor_face_mask.json \
    infer-config=/jsons/kernel_dpu_face_mask.json ! \
  vvas_xfilter kernels-config=/jsons/kernel_bbox_face_mask.json ! \
  videoconvert ! jpegenc quality=60 ! rtpjpegpay ! \
  udpsink host=192.168.123.128 port=5000
```

**Step 9 — View on dev PC:**

```bash
# Capture frames to disk (verifies pipeline works):
gst-launch-1.0 udpsrc port=5000 \
  caps="application/x-rtp,media=video,clock-rate=90000,encoding-name=JPEG,payload=26" ! \
  rtpjpegdepay ! multifilesink location="/tmp/frame%05d.jpg" max-files=5
# Ctrl+C after 2-3 seconds, then open /tmp/frame00000.jpg

# Live display (GTK window — works on both X11 and Wayland):
gst-launch-1.0 udpsrc port=5000 \
  caps="application/x-rtp,media=video,clock-rate=90000,encoding-name=JPEG,payload=26" ! \
  rtpjpegdepay ! jpegdec ! videoconvert ! gtksink sync=false
```

> The GTK window shows a live feed. If the room/scene is dark or empty, the image will appear black — this is correct behaviour. Bounding boxes appear when faces are in frame.

---

### Phase 7 — Socket Servers as systemd Services

**Status: Not yet done on Ubuntu board.**

The three Python socket servers (`app-server.py`, `xmutil-server.py`, `vitis-server.py`) run identically on Ubuntu 22.04 — Python 3.10 is built in, and Ubuntu's systemd is full-featured, making persistence trivial.

```bash
# On dev PC: SCP the server scripts to the board
scp smartapp-modified/kv260-smartapp-clusterserver/server/app-server.py    ubuntu@192.168.123.118:/home/ubuntu/servers/
scp smartapp-modified/kv260-smartapp-clusterserver/server/xmutil-server.py ubuntu@192.168.123.118:/home/ubuntu/servers/
scp smartapp-modified/kv260-smartapp-clusterserver/server/vitis-server.py  ubuntu@192.168.123.118:/home/ubuntu/servers/

# On the board: install any Python deps
pip3 install --user <whatever the servers require>
```

Create systemd unit files on the board:

```bash
# /etc/systemd/system/xmutil-server.service
sudo tee /etc/systemd/system/xmutil-server.service << 'EOF'
[Unit]
Description=KV260 xmutil socket server
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/usr/bin/python3 /home/ubuntu/servers/xmutil-server.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Repeat for app-server.service and vitis-server.service (same pattern, different ExecStart)

sudo systemctl daemon-reload
sudo systemctl enable --now xmutil-server app-server vitis-server

# Verify:
sudo systemctl status xmutil-server
```

---

### Phase 8 — `ninoctl` CLI Integration

**Status: No changes needed to ninoctl source. Cross-compile and deploy.**

`ninoctl` is a pure Go CLI that talks to the socket servers over TCP. It has no OS-specific dependencies.

```bash
# On dev PC: cross-compile for ARM64
cd smartapp-modified/kv260-smartapp-cli
GOARCH=arm64 GOOS=linux go build -o ninoctl-arm64 ./src/

# Test basic connectivity:
./ninoctl-arm64 --host 192.168.123.118 listapps
```

No changes to the Go source are needed. The board IP (`192.168.123.118`) and socket ports are the only environment-specific values.

---

### Phase 9 — KubeEdge Pod Manifests (Update for Ubuntu)

The existing `xmutil.yaml` and `app-pod.yaml` manifests from `smartapp-modified/kv260-smartapp-clusterserver/deployment/` apply with minor path adjustments for Ubuntu (e.g. home directory is `/home/ubuntu/` instead of `/home/petalinux/`).

Key manifest sections to verify:
```yaml
# app-pod.yaml — ensure these host paths match Ubuntu layout:
volumes:
- name: dev-dir
  hostPath: { path: /dev }
- name: models-dir
  hostPath: { path: /home/ubuntu/models }   # was /home/petalinux/... on Yocto
- name: jsons-dir
  hostPath: { path: /home/ubuntu/jsons }
```

Apply via kubectl on the master as before:
```bash
kubectl apply -f deployment/xmutil.yaml
kubectl apply -f deployment/app-pod.yaml
```

---

## Persistence: What Survives Reboot

On Ubuntu 22.04, achieving full boot-persistence is easier than on the Yocto minimal image:

| Component | How to persist |
|---|---|
| `xmutil loadapp kv260-smartcam` | Add to `/etc/rc.local` or create a systemd `oneshot` unit |
| `ap1302` driver | Auto-loads on Ubuntu when overlay is applied — no manual insmod needed |
| `media-ctl` pad format fixup | Udev rule triggered on `/dev/video0` appearance |
| Socket servers | systemd services (Phase 7 above) |
| `edgecore` | `keadm join` already registers it as a systemd service automatically |
| Docker container pipeline | Create a systemd service that runs `docker run ...` on boot |

---

## Version Compatibility Notes

Your Phase 1 artifacts were compiled with **Vitis-AI 2022.1-era toolchain**, targeting `DPUCZDX8G_ISA1_B3136`. The `xilinx/smartcam:2022.1` container ships the matching VART/VVAS runtime for that DPU generation — so your pre-compiled `.xmodel` files will load cleanly inside that container without any recompilation.

If you ever update to newer Vitis-AI (e.g. 3.0+), you would need to:
1. Recompile `.xmodel` files against the new arch (Phase 1, Vitis-AI Docker step)
2. Switch to a matching newer container runtime
3. Reverify the `vart.conf` `xclbin` path

The XRT/zocl version-pin problem you hit in Yocto (`RDEPENDS` mismatch causing `do_rootfs` failure) effectively **goes away on Ubuntu** — AMD aligns their apt packages so `xlnx-firmware-kv260-smartcam` and the VART runtime in the `xilinx/smartcam:2022.1` container are pre-tested together.

---

## What This Migration Does NOT Change

These remain identical and are unaffected by the OS change:

- **Vivado/Vitis 2022.1 platform build** (dev PC, Ubuntu 20.04 Docker)
- **Vitis-AI model quantization + compilation** (dev PC, `xilinx/vitis-ai:2.5` Docker)
- **KubeEdge `cloudcore` on the Proxmox master VM**
- **`keadm join` command syntax and token flow**
- **`ninoctl` Go source code**
- **Socket server Python logic** (`app-server.py`, `xmutil-server.py`, `vitis-server.py`)
- **Model deployment path** (SCP `.xmodel` files to board, symlink trick for slot override)
- **GStreamer pipeline structure** (same VVAS plugins, same pad caps)

---

## Phase Summary

| Phase | Action | Effort | Status |
|---|---|---|---|
| 1 | Hardware overlay + model compile (dev PC) | None — already done | ✅ Complete |
| 2 | Flash stock Ubuntu 22.04 to board | ~10 min | ✅ Complete |
| 4 | containerd + CNI install | ~15 min | ✅ Done |
| 5 | `keadm join` | ~10 min | ✅ Done |
| 6A | Load overlay + mount custom model into smartcam container | ~30 min | ⚠️ Blocked — v4l2src buffer pool failure on /dev/video2; see Phase 6 Known Issues |
| 6B | Package + deploy custom `kv260-vvas-sms` overlay (optional) | ~1–2 hrs | ✅ Done — pipeline confirmed working; live frames captured on dev PC |
| 7 | Socket servers as systemd services | ~20 min | ⬜ TODO |
| 8 | `ninoctl` cross-compile + test | ~10 min | ⬜ TODO |
| 9 | Update KubeEdge pod manifests for Ubuntu paths | ~15 min | ⬜ TODO |
| — | Per-boot persistence (systemd units, udev rules) | ~30 min | ⬜ TODO |

**Total estimated effort from current state (Ubuntu board already working): ~2–3 hours.**
