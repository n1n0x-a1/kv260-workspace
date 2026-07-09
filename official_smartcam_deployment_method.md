# Official `xilinx/smartcam` Deployment Method

> Documents the alternate, faster path to a working face-detection demo on the KV260: flashing the **stock Kria Ubuntu 22.04 "classic desktop" image** and running AMD/Xilinx's **official prebuilt `xlnx-firmware-kv260-smartcam` overlay + `xilinx/smartcam:2022.1` Docker container**, instead of the custom Yocto/PetaLinux + KubeEdge pipeline documented in [README.md](README.md).
>
> **Status**: Confirmed working — live face-detection bounding boxes are streamed over RTSP from the board to a dev PC. It does **not** yet have Kubernetes/KubeEdge connectivity or the ability to deploy custom-compiled models — see [Cons](#cons) below.

---

## What This Method Actually Is

This is the path AMD's own [Kria SmartCamera app deployment docs](https://xilinx.github.io/kria-apps-docs/kv260/2022.1/build/html/docs/smartcamera/docs/app_deployment.html) describe, run essentially unmodified:

1. Flash the **prebuilt Kria Ubuntu 22.04 LTS classic-desktop image** (`iot-limerick-kria-classic-desktop-2204-*.img.xz`) directly to the SD card — no Yocto/PetaLinux build involved at all.
2. Boot it, log in (`ubuntu`/`ubuntu`), add the Xilinx APT repo, and `apt install xlnx-firmware-kv260-smartcam` — an AMD-signed, prebuilt FPGA overlay package.
3. Load it with `xmutil unloadapp` / `xmutil loadapp kv260-smartcam` (same `xmutil` slot mechanism used elsewhere in this project, but pointed at AMD's own reference overlay instead of the custom `kv260-vvas-sms` one).
4. `docker pull xilinx/smartcam:2022.1` and run it with `--privileged --net=host` and the usual `/dev`, `/sys`, `/tmp` bind mounts.
5. Inside the container, the prebuilt `smartcam` CLI tool runs a ready-made GStreamer + VVAS + DPU pipeline against either a USB webcam or the MIPI/AR1335 sensor, encoding to RTSP (port 554) or piping to the local display.
6. On the dev PC, `ffplay rtsp://<board-ip>:554/test` displays the live feed with bounding boxes already drawn by the container's bundled face-detection model.

No Vivado/Vitis platform build, no Vitis-AI model compilation, no Yocto `bitbake`, and no custom application code (`smart_model_select.c`) are involved — everything is AMD-prebuilt and apt/Docker-installed.

### Key commands (condensed)
```bash
# On the board (after flashing stock Ubuntu 22.04 and logging in)
sudo add-apt-repository ppa:xilinx-apps/ppa   # or manually add the Xilinx APT key/list
sudo apt update
sudo apt install xlnx-firmware-kv260-smartcam docker.io -y
sudo usermod -aG docker $USER && newgrp docker

sudo xmutil desktop_disable
sudo xmutil unloadapp
sudo xmutil loadapp kv260-smartcam

docker pull xilinx/smartcam:2022.1
docker run --env="DISPLAY" -h "xlnx-docker" --env="XDG_SESSION_TYPE" \
  --net=host --privileged \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v /tmp:/tmp -v /dev:/dev -v /sys:/sys \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx -v /run:/run \
  -it xilinx/smartcam:2022.1 bash

# Inside the container — pick one source:
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp     # USB webcam
bash 01.mipi-rtsp.sh                                     # MIPI/AR1335 sensor
```
```bash
# On the dev PC (same subnet)
ffplay rtsp://<board-ip>:554/test
```

---

## Comparison: Official Smartcam vs. Custom Yocto/KubeEdge Pipeline

| Aspect | **Official `smartcam` (this doc)** | **Custom Yocto + KubeEdge (`README.md`)** |
| :--- | :--- | :--- |
| Base OS | Stock Kria Ubuntu 22.04 "classic desktop" image, prebuilt by AMD | Custom-built Yocto/PetaLinux `petalinux-image-minimal` (Scarthgap, 2024.2), built from source via `bitbake` |
| FPGA overlay | AMD-prebuilt `xlnx-firmware-kv260-smartcam` package (apt-installed) | Custom-synthesized `kv260-vvas-sms` overlay (own Vivado/Vitis platform build + DPU integration) |
| App runtime | AMD's prebuilt `xilinx/smartcam:2022.1` Docker image, fixed `smartcam` CLI | Custom `smart_model_select` C app, hand-built VVAS GStreamer pipeline (`vvas_xinfer`/`vvas_xfilter`) |
| AI model | Fixed, bundled inside the container (face detection / ADAS SSD only) | Custom-compiled Vitis-AI models (`yolov3_voc_tf`, `face_mask_detection_pt`) targeting this project's own DPU arch, swappable via the slot-symlink trick |
| Setup time | ~1–1.5 hrs (mostly image flash + Docker pull) | Multiple sessions: Vitis platform build, DPU synthesis, model compile, full Yocto build, SD partitioning fixes, KubeEdge bring-up |
| Toolchain version | PetaLinux/Vitis-AI 2022.1-era | PetaLinux/Vitis 2022.1 for hardware synthesis, but OS image is current Yocto Scarthgap (2024.x) |
| Kubernetes/KubeEdge | ❌ None — no `edgecore`, no `cloudcore` join, no cluster membership | ✅ Full `keadm join` flow, cgroup v1 patched `system.dtb`, node joins as `Ready` in the cluster |
| Custom model deployment | ❌ Not supported — `smartcam` CLI has no model-swap mechanism | ✅ Supported via model-slot symlinking + custom kernel JSON generation (`kernel_dpu_*.json`, etc.) |
| Remote orchestration (`ninoctl`, socket servers) | ❌ Not integrated | ✅ `app-server.py`/`xmutil-server.py`/`vitis-server.py` + Go CLI |
| Reproducibility / fragility | High — apt + Docker, AMD-maintained, few moving parts | Lower — hand-maintained Yocto layer, hit a real `wic`/`--exclude-path` partition-sizing bug during this project's own rebuild |
| Image size / footprint | Larger (full Ubuntu desktop base + several-GB Docker pull) | Smaller (Yocto minimal image), tunable via `IMAGE_ROOTFS_EXTRA_SPACE` |
| Persistence across reboot | App/overlay must be reloaded manually each boot (`xmutil loadapp`, `docker run`) unless scripted into a systemd unit | Same caveat applies today for the live face-detection setup (not yet baked into image either) |

---

## Pros

- **Fast time-to-working-demo.** End-to-end face-detection-over-RTSP was working in roughly the time it takes to flash an SD card and pull one Docker image — no hardware synthesis, no model compilation, no Yocto build required.
- **Officially supported and tested.** The overlay and container come straight from AMD/Xilinx's own release channel, side-stepping the class of bugs this project has hit in its own custom build (e.g. the `xilinx-default-sd.wks` `--exclude-path` bug that silently discarded `IMAGE_ROOTFS_EXTRA_SPACE`, or the `xrt`/`zocl` version-pin mismatch).
- **Low maintenance burden.** Updating the app is just `docker pull` of a new tag; no rebuild pipeline to keep working.
- **Good for quick validation.** Useful as a sanity check that the board's camera/DPU hardware path works at all, independent of any of this project's custom overlay/model work.
- **Self-contained.** Doesn't depend on the Vitis platform build, Vitis-AI model compilation flow, or any of the `smartapp-modified` submodule tooling — fewer prerequisites.

## Cons

- **No Kubernetes/KubeEdge integration.** This was a central goal of the project (`README.md` Phase 5) — orchestrating a fleet of KV260 nodes from a central master via `cloudcore`/`edgecore`. The stock Ubuntu desktop image has none of the cgroup v1 boot-param patching, `edgecore` binary, or CNI setup the custom image carries. Adopting this method means giving up fleet management entirely unless it's re-added on top (non-trivial, since it would mean replicating the `meta-kubeedge` layer's work on an Ubuntu base instead of Yocto).
- **No custom/swappable model deployment.** The bundled `smartcam` CLI only runs whatever model AMD baked into the `xilinx/smartcam:2022.1` image (face detection, ADAS SSD). There's no equivalent of the model-slot-symlink trick or kernel-JSON generation used with `smart_model_select` — so this project's own compiled models (`face_mask_detection_pt`, `yolov3_voc_tf`) can't be deployed through this path at all today.
- **No remote control tooling.** The `ninoctl` CLI and the three socket servers (`app-server.py`, `xmutil-server.py`, `vitis-server.py`) have nothing to talk to here — there's no API/socket surface inside the official container.
- **Older toolchain baseline.** The container is pinned to 2022.1-era Vitis-AI/VART; mixing in artifacts built against this project's 2024.2 PetaLinux/Yocto pipeline isn't guaranteed to be binary-compatible.
- **Mutually exclusive with the custom image.** The stock Ubuntu desktop image and the custom Yocto image are two different bootable OS images — switching between them means reflashing the SD card, not something incremental. You can't run both pipelines on the same boot.
- **Heavier footprint.** Full Ubuntu desktop base + multi-GB Docker pull vs. a deliberately minimal Yocto rootfs.

---

## Where This Leaves the Project

This method is best understood as a **parallel, low-effort validation path**, not a replacement for the custom Yocto/KubeEdge pipeline:

- Use it when the goal is *"does face detection work on this hardware at all"* — it's the fastest way to get a visual yes/no answer.
- Continue using the custom Yocto + `smart_model_select` + KubeEdge pipeline (`README.md`) for anything that needs **fleet orchestration** or **custom/compiled models** — neither is available here, and closing those two gaps on top of the stock Ubuntu image would mean re-implementing most of what `meta-kubeedge` and `smart_model_select` already do, just on a different base OS.
