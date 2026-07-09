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
├── Vitis-AI Docker (xilinx/vitis-ai:2.5)                        │
│   └── Compiles: .xmodel files (face_mask_detection_pt, etc.)   │
├── Yocto/BitBake build environment (kv260-yocto Docker)         │
│   └── Builds: petalinux-image-minimal.wic.gz  ─────────────┐  │
└── ninoctl CLI (Go binary)                                   │  │
                                                              │  │
KV260 Board (ARM64 Cortex-A53, IP: 192.168.123.118)          │  │
├── OS: Custom Yocto/PetaLinux Scarthgap minimal  ◄───────────┘  │
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
| cgroup v1 for edgecore | Decompile/edit/recompile `system.dtb` bootargs | Edit `/etc/default/grub` + `update-grub` |
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

### Phase 3 — Enable cgroup v1 (Required for KubeEdge `edgecore`)

**Status: Not yet done on the Ubuntu board.**

On the Yocto image, this required decompiling `system.dtb`, editing `bootargs`, recompiling, and copying the modified file to the boot partition — a fragile multi-step process. On Ubuntu, it is a single file edit:

```bash
# On the KV260 board:
sudo nano /etc/default/grub
```

Change the `GRUB_CMDLINE_LINUX` line to:
```
GRUB_CMDLINE_LINUX="cgroup_enable=memory cgroup_memory=1 systemd.unified_cgroup_hierarchy=0"
```

Then apply and reboot:
```bash
sudo update-grub
sudo reboot
```

After reboot, verify:
```bash
# Should show cgroup v1 hierarchy active:
ls /sys/fs/cgroup/memory/
# If this directory exists and has content, cgroup v1 is working
```

---

### Phase 4 — Install containerd + CNI Plugins

**Status: Not yet done on the Ubuntu board.**

```bash
# Install containerd
sudo apt install -y containerd

# Generate default config and configure cgroupfs driver (required for keadm)
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Edit config.toml to use cgroupfs (not systemd) driver:
sudo sed -i 's/SystemdCgroup = true/SystemdCgroup = false/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Install CNI plugins
sudo mkdir -p /opt/cni/bin
wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-arm64-v1.3.0.tgz
sudo tar -xzf cni-plugins-linux-arm64-v1.3.0.tgz -C /opt/cni/bin/
```

---

### Phase 5 — KubeEdge `edgecore` Join

**Status: Not yet done on the Ubuntu board. Commands are identical to what the README's Phase 5 already documents.**

```bash
# Download keadm for ARM64 (match version to your cloudcore version on the master)
# Check your master: ssh <master-ip> "keadm version"
wget https://github.com/kubeedge/kubeedge/releases/download/v1.15.0/keadm-v1.15.0-linux-arm64.tar.gz
tar -xzf keadm-v1.15.0-linux-arm64.tar.gz
sudo mv keadm-v1.15.0-linux-arm64/keadm /usr/local/bin/keadm

# Get token from master:
# (run on the master VM)
# keadm gettoken --kube-config=/root/.kube/config

# Join the cluster:
sudo keadm join \
  --cloudcore-ipport=<master-ip>:10000 \
  --token=<token-from-master> \
  --cgroupdriver=cgroupfs \
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
scp -r /path/to/face_mask_detection_pt/  ubuntu@192.168.123.118:/home/ubuntu/models/
scp -r /path/to/kernel_jsons/            ubuntu@192.168.123.118:/home/ubuntu/jsons/
scp /path/to/dpu.xclbin                  ubuntu@192.168.123.118:/home/ubuntu/

# Update /etc/vart.conf on the board to point to your xclbin:
sudo bash -c 'cat > /etc/vart.conf << EOF
{
  "target": "dpuczdx8g",
  "xclbin": "/home/ubuntu/dpu.xclbin"
}
EOF'
```

Run the custom pipeline inside the existing smartcam container:
```bash
docker run --privileged --net=host \
  -v /dev:/dev -v /sys:/sys -v /tmp:/tmp -v /run:/run \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx \
  -v /home/ubuntu/models:/models \
  -v /home/ubuntu/jsons:/jsons \
  -it xilinx/smartcam:2022.1 bash

# Inside the container — CSI camera bring-up (same as before):
insmod /tmp/ap1302.ko   # if custom overlay requires it; skip if kv260-smartcam handles it
media-ctl -V '"ap1302.4-003c":2 [fmt:VYYUYY8_1X24/1920x1080]'
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=NV12

# Run inference pipeline with face_mask_detection_pt:
gst-launch-1.0 \
  v4l2src device=/dev/video0 io-mode=mmap ! \
  video/x-raw,format=NV12,width=1920,height=1080 ! \
  vvas_xinfer \
    preprocess-config=/jsons/kernel_preprocessor_face_mask.json \
    infer-config=/jsons/kernel_dpu_face_mask.json ! \
  vvas_xfilter kernels-config=/jsons/kernel_bbox_face_mask.json ! \
  videoconvert ! jpegenc ! rtpjpegpay ! \
  udpsink host=192.168.123.128 port=5000
```

On the dev PC:
```bash
ffplay stream.sdp    # reuse existing stream.sdp from prior session
```

#### Approach B: Deploy your custom `kv260-vvas-sms` overlay

Best when you need the custom DPU bitstream you synthesized in Phase 1 (e.g. for a different DPU config, or to package it alongside future custom kernels).

```bash
# Package the overlay as a firmware bundle on the dev PC:
# Your Phase 1 output directory should have:
#   kv260-vvas-sms.bit      → convert to .bit.bin
#   kv260-vvas-sms.dtbo
#   shell.json

# Convert .bit → .bit.bin (if not already done):
# (run in Vitis container or on host with Xilinx tools)
bootgen -arch zynqmp -image kv260-vvas-sms.bif -o kv260-vvas-sms.bit.bin -w on

# SCP the firmware bundle to the board:
ssh ubuntu@192.168.123.118 "sudo mkdir -p /lib/firmware/xilinx/kv260-vvas-sms"
scp kv260-vvas-sms.bit.bin  ubuntu@192.168.123.118:/tmp/
scp kv260-vvas-sms.dtbo     ubuntu@192.168.123.118:/tmp/
scp shell.json               ubuntu@192.168.123.118:/tmp/
ssh ubuntu@192.168.123.118 \
  "sudo mv /tmp/kv260-vvas-sms.* /lib/firmware/xilinx/kv260-vvas-sms/ && \
   sudo mv /tmp/shell.json /lib/firmware/xilinx/kv260-vvas-sms/"

# Load your custom overlay:
sudo xmutil unloadapp
sudo xmutil loadapp kv260-vvas-sms

# Deploy models to the expected path (same as Yocto — path is part of the VVAS config, not OS):
sudo mkdir -p /opt/xilinx/kv260-vvas-sms/models.b3136/
scp -r /path/to/models.b3136/ ubuntu@192.168.123.118:/opt/xilinx/kv260-vvas-sms/
```

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
| `insmod ap1302.ko` | Place `.ko` in `/lib/modules/$(uname -r)/extra/` + `depmod -a` + `modprobe ap1302` in a udev rule |
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
| 3 | cgroup v1 via GRUB edit | ~5 min | ⬜ TODO |
| 4 | containerd + CNI install | ~15 min | ⬜ TODO |
| 5 | `keadm join` | ~10 min | ⬜ TODO |
| 6A | Load overlay + mount custom model into smartcam container | ~30 min | ⬜ TODO |
| 6B | Package + deploy custom `kv260-vvas-sms` overlay (optional) | ~1–2 hrs | ⬜ Optional |
| 7 | Socket servers as systemd services | ~20 min | ⬜ TODO |
| 8 | `ninoctl` cross-compile + test | ~10 min | ⬜ TODO |
| 9 | Update KubeEdge pod manifests for Ubuntu paths | ~15 min | ⬜ TODO |
| — | Per-boot persistence (systemd units, udev rules) | ~30 min | ⬜ TODO |

**Total estimated effort from current state (Ubuntu board already working): ~2–3 hours.**
