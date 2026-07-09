# KV260 Current Architecture — Ubuntu 22.04

> **Active development path** as of July 2026.
> Stock Kria Ubuntu 22.04 LTS + AMD's `xilinx/smartcam:2022.1` Docker container.
> No custom OS build required.

**Maintainer**: Steven Pratama — [@syvesdh](https://github.com/syvesdh)

---

## Why We Moved Off Yocto

The custom Yocto/PetaLinux build was abandoned after several compounding issues with no clean fix:

| Problem | Root Cause | Status |
|---|---|---|
| `CONFIG_VIDEO_AP1302` disabled | Not in default Xilinx kernel config | Required manual `menuconfig` + module rebuild every clean build |
| USB webcam (Logitech C270) not detected | `uvcvideo` + `usb5744` hub driver incompatibility | Confirmed kernel bug, no fix without patching the kernel |
| VCU/Allegro H.264 encoder missing | Not compiled into `linux-xlnx` image | Missing entirely from the build |
| KubeEdge `edgecore` cgroup v1 requirement | Ubuntu 22.04 defaults to cgroup v2 | Required hand-patching `system.dtb` bootargs on every flash |
| Yocto WKS partition sizing bug | `WKS_FULL_PATH` resolves to vendor file despite override | Root partition too small; required manual `resize2fs` after every flash |

AMD's official Ubuntu 22.04 Kria image solves all of these out of the box: AP1302 drivers are included, cgroup v1 is configurable via `grub`, and the rootfs is already sized correctly.

---

## Current Architecture

```
┌─────────────────────────────────────────────────────┐
│              Dev PC (Ubuntu 24.04)                  │
│  ffplay rtsp://192.168.123.118:554/test             │
│  ninoctl (Go CLI, cross-compiled arm64)             │
│  kubectl / keadm (KubeEdge master side)             │
└─────────────────┬───────────────────────────────────┘
                  │ Ethernet (192.168.123.0/24)
┌─────────────────▼───────────────────────────────────┐
│         KV260 — Ubuntu 22.04 LTS (Stock Kria)       │
│                                                     │
│  xmutil loadapp kv260-smartcam                      │
│    └─ FPGA overlay: DPU + CSI/ISP + multiscaler     │
│                                                     │
│  docker run xilinx/smartcam:2022.1                  │
│    └─ GStreamer + VVAS plugins (vvas_xinfer, etc.)  │
│    └─ VART/XRT runtime                              │
│    └─ face_mask_detection_pt.xmodel (DPU inference) │
│    └─ RTSP output → port 554                        │
│                                                     │
│  edgecore (KubeEdge) ──► cloudcore on master VM     │
│  Socket servers (Python): app / xmutil / vitis      │
└─────────────────────────────────────────────────────┘
```

### Key Components

| Component | What it is | Where |
|---|---|---|
| `xilinx/smartcam:2022.1` | Docker image with GStreamer + VVAS + VART/XRT | `docker pull xilinx/smartcam:2022.1` |
| `kv260-smartcam` overlay | FPGA bitstream: DPU + CSI + multiscaler | `/lib/firmware/xilinx/kv260-smartcam/` (installed via `xlnx-firmware-kv260-smartcam`) |
| `face_mask_detection_pt` | Compiled DPU model (YOLO-Fastest, 2 classes) | `ubuntu-migration/models/face_mask_detection_pt/` |
| `dpu.xclbin` | FPGA accelerator binary (B3136 DPU) | `ubuntu-migration/dpu.xclbin` |
| `edgecore` | KubeEdge lightweight edge daemon | Static ARM64 binary, installed via `keadm join` |
| Socket servers | Python: `app-server.py`, `xmutil-server.py`, `vitis-server.py` | `smartapp-modified/kv260-smartapp-clusterserver/server/` |
| `ninoctl` | Go CLI for remote orchestration | `smartapp-modified/kv260-smartapp-cli/` |

---

## Workspace Structure

```
kv260-workspace/
├── README.md                       ← Legacy Yocto architecture + pointer here
├── Dockerfile                      ← Legacy Yocto build container
│
├── docs/yocto/                     ← Legacy reference only
│   ├── camera_research_guide.md
│   ├── camera_setup_guide.md
│   ├── usb_webcam_quickstart.md
│   ├── k8s_network_architecture.md
│   └── pipelines2.png
│
├── ubuntu-migration/               ← Active deployment artifacts + docs
│   ├── docs/                       ← YOU ARE HERE (current architecture)
│   │   ├── README.md
│   │   ├── ubuntu_migration_plan.md        ← 9-phase migration plan
│   │   ├── ubuntu_migration_research.md    ← Why-to-migrate rationale
│   │   ├── official_smartcam_deployment_method.md
│   │   ├── smartcam_deployment_guide.md    ← Step-by-step deployment guide
│   │   └── smartcam_deployment_timeline.md ← Raw session log
│   ├── dpu.xclbin                          ← FPGA accelerator binary (7.6MB)
│   ├── arch.json                           ← DPU arch fingerprint (DPUCZDX8G_ISA1_B3136)
│   ├── overlay/                            ← kv260-vvas-sms FPGA overlay files
│   ├── models/face_mask_detection_pt/      ← Compiled .xmodel + labels
│   └── jsons/                             ← VVAS kernel JSON configs
│
├── smartapp-modified/              ← Go CLI + Python servers + K8s manifests
└── yocto-xilinx/                  ← Legacy Yocto build (archived)
```

---

## Quick Start (From Zero to Live Stream)

> Full step-by-step guide with real terminal output: [`smartcam_deployment_guide.md`](smartcam_deployment_guide.md)

```bash
# --- On KV260 board (Ubuntu 22.04, via UART ttyUSB1 @ 115200) ---

# 1. Add Xilinx repo
sudo add-apt-repository ppa:xilinx-apps/ppa && sudo apt update

# 2. Install firmware + Docker
sudo apt install xlnx-firmware-kv260-smartcam docker.io -y
sudo systemctl enable --now docker
sudo usermod -aG docker $USER && newgrp docker

# 3. Load FPGA overlay
sudo xmutil desktop_disable
sudo xmutil unloadapp
sudo xmutil loadapp kv260-smartcam     # press Enter after kernel messages

# 4. Pull image (once, several GB)
docker pull xilinx/smartcam:2022.1

# 5. Run container
docker run --env="DISPLAY" -h "xlnx-docker" --env="XDG_SESSION_TYPE" \
  --net=host --privileged \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v /tmp:/tmp -v /dev:/dev -v /sys:/sys \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx -v /run:/run \
  -it xilinx/smartcam:2022.1 bash

# 6. Inside container — face detection via USB webcam → RTSP
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp

# --- On dev PC ---
ffplay rtsp://192.168.123.118:554/test
```

> **Port**: RTSP uses **554**, not 5000. The `stream ready at:` output in the container confirms this.

---

## Deployment Phases

| Phase | Description | Status | Doc |
|---|---|---|---|
| 1 | Flash Ubuntu 22.04 + Docker + firmware | ✅ Done | [`smartcam_deployment_guide.md`](smartcam_deployment_guide.md) |
| 2 | Load `kv260-smartcam` overlay + run `xilinx/smartcam:2022.1` | ✅ Done | Same |
| 3 | Enable cgroup v1 (required for KubeEdge `edgecore`) | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 3 |
| 4 | Install containerd + CNI plugins | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 4 |
| 5 | `keadm join` — connect KV260 to KubeEdge master | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 5 |
| 6 | Deploy custom model (`face_mask_detection_pt`) via bind-mount | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 6 |
| 7 | Deploy socket servers as systemd services | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 7 |
| 8 | Cross-compile + deploy `ninoctl` (ARM64) | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 8 |
| 9 | Update KubeEdge pod manifests for Ubuntu paths | ⬜ Pending | [`ubuntu_migration_plan.md`](ubuntu_migration_plan.md) Phase 9 |

---

## Environment

| Item | Value |
|---|---|
| Board | Xilinx Kria KV260 Vision AI Starter Kit |
| Board OS | Ubuntu 22.04 LTS (Kria classic desktop image) |
| Board IP | `192.168.123.118` |
| Dev PC OS | Ubuntu 24.04 |
| Dev PC IP | `192.168.123.128` |
| UART port | `/dev/ttyUSB1` @ 115200 baud |
| Default login | `ubuntu` / `ubuntu` (forced change on first login) |
| Docker registry | `docker.io` (not snap) |
| RTSP URL | `rtsp://192.168.123.118:554/test` |
| DPU target | `DPUCZDX8G_ISA1_B3136` |
| Model | `face_mask_detection_pt` (YOLO-Fastest, 2 classes: Mask / No Mask) |
