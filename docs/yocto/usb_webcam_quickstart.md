# 🎥 Logitech C270 USB Webcam → KV260 Quick Demo Guide

> **Goal**: Get a live AI (face detection) demo running as fast as possible using the C270 plugged into the KV260.

---

## ⚡ The Big Picture: NO REBUILD REQUIRED!

Previously, it was thought that you needed to rebuild the Yocto kernel because `CONFIG_USB_VIDEO_CLASS` was not active as a loadable module. However, **the kernel running on the board already has the UVC driver built-in (`=y`)**. 

The reason the Logitech C270 was not detected was that **the onboard Microchip USB5744 hub controller module (`usb5744.ko`) was not loaded**. Without it, the USB hub remained in reset, keeping the physical USB ports powered off.

### The Fix

Run these commands on the KV260 board to load the USB hub driver and make it persist across reboots:

```bash
# 1. Load the USB hub driver module
root@zynqmp-generic:~# modprobe usb5744

# 2. Configure the module to load automatically on boot
root@zynqmp-generic:~# echo usb5744 > /etc/modules-load.d/usb5744.conf

# 3. Verify the USB camera is now electrically detected
root@zynqmp-generic:~# lsusb
# Look for: "Bus 001 Device 003: ID 046d:0825 Logitech, Inc. Webcam C270"
```

Once loaded, the built-in `uvcvideo` driver binds to the webcam and automatically creates `/dev/video1` and `/dev/video2`.

---

## Step 0: Verify the Camera is Detected

Confirm the webcam is seen and its device nodes are available:

```bash
# Run on the KV260 (ssh root@192.168.123.117)
ls -la /dev/video*
# Expected output:
# /dev/video0 (onboard MIPI CSI-2)
# /dev/video1 (Logitech C270 Webcam video stream)
# /dev/video2 (Logitech C270 Webcam metadata stream)
```

You can also verify the nodes from within the `kv260-xmutil` containerd container:

```bash
# Execute within containerd task:
ctr -n k8s.io tasks exec --exec-id check_v4l2 <container-id> v4l2-ctl --list-devices

# Expected output:
# C270 HD WEBCAM (usb-xhci-hcd.1.auto-1.2):
# 	/dev/video1
# 	/dev/video2
# 	/dev/media0
```

> [!TIP]
> The C270 typically registers as `/dev/video0` or `/dev/video2` depending on whether the MIPI ISP pipeline has already reserved `/dev/video0` and `/dev/video1`. Check the output of `--list-devices` carefully.

```bash
# Confirm it can capture at 720p/30fps (C270 spec)
v4l2-ctl -d /dev/videoX --list-formats-ext
# Look for: YUYV or MJPG at 1280x720 @ 30fps
```

> [!NOTE]
> The C270 is a **720p** webcam (1280×720 @ 30fps). The `smartcam` app defaults to 1920×1080 — **you must override** this with `-W 1280 -H 720`.

---

## Step 1: Load the smartcam FPGA Overlay via xmutil

The `smartcam` app requires the **kv260-smartcam** bitstream to be loaded first for the DPU accelerator.

### Option A: Your system is running on bare Yocto (direct SSH)

```bash
# On KV260 — unload any currently loaded overlay first
sudo xmutil unloadapp

# Load the smartcam overlay
sudo xmutil loadapp kv260-smartcam

# Verify it's listed and active
sudo xmutil listapps
```

### Option B: Your overlay is the custom kv260-vvas-sms (current setup)

Based on your README, your system uses `kv260-vvas-sms` (your custom VVAS overlay). The **standard `xilinx/smartcam:2022.1` Docker** expects `kv260-smartcam` firmware.

**Check what's currently loaded:**
```bash
sudo xmutil listapps
```

**If `kv260-vvas-sms` is your only overlay**, you have two options:

#### Option B1: Install the official smartcam firmware (fastest for demo)
This only works if your Yocto image includes the Xilinx APT feed (Ubuntu-based KSK image):
```bash
# This requires the Xilinx Ubuntu 22.04 KSK image, not the custom Yocto image
sudo apt install xlnx-firmware-kv260-smartcam
sudo xmutil unloadapp
sudo xmutil loadapp kv260-smartcam
```

#### Option B2: Use the existing xmutil-app container pipeline (your current setup)
Skip to **Step 2B** below — use a raw GStreamer pipeline inside your existing container instead.

---

## Step 2A: Run via Official smartcam Docker (Fastest Demo — Ubuntu KSK path)

**On KV260**, after loading `kv260-smartcam`:

```bash
# Pull the prebuilt Xilinx smartcam container (do this over network or pre-pull)
docker pull xilinx/smartcam:2022.1

# Launch the container with full hardware access
docker run \
  --env="DISPLAY" \
  -h "xlnx-docker" \
  --env="XDG_SESSION_TYPE" \
  --net=host \
  --privileged \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v /tmp:/tmp \
  -v /dev:/dev \
  -v /sys:/sys \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx \
  -v /run:/run \
  -it xilinx/smartcam:2022.1 bash
```

**Inside the container**, stream the C270 over RTSP with face detection:

```bash
# Replace <N> with your C270's video device number (e.g., 2 for /dev/video2)
smartcam --usb <N> -W 1280 -H 720 -r 30 --target rtsp --aitask facedetect

# Stream will be available at:
# rtsp://192.168.123.117:5000/test
```

**On your laptop**, open the stream:
```bash
# Option A: ffplay
ffplay rtsp://192.168.123.117:5000/test

# Option B: VLC
vlc rtsp://192.168.123.117:5000/test
```

---

## Step 2B: Raw GStreamer Pipeline (Works with Your Existing kv260-vvas-sms Overlay)

If you're using your custom VVAS overlay and want a fast raw camera preview **without** needing the smartcam app, use this inside the `xmutil-app` container:

```bash
# Exec into your existing xmutil-app container
kubectl exec -it <xmutil-app-pod-name> -- /bin/bash
# OR from the KV260 directly:
# ctr -n k8s.io tasks exec --exec-id shell1 -t <container-id> /bin/bash
```

**Option 1 — UDP/RTP stream (no DPU inference, just raw video):**
```bash
# Raw USB webcam → H264 encode → UDP stream to laptop
# Replace /dev/video2 with your C270 device node
gst-launch-1.0 v4l2src device=/dev/video2 ! \
  video/x-raw,width=1280,height=720,framerate=30/1 ! \
  videoconvert ! \
  omxh264enc target-bitrate=3000 control-rate=low-latency gop-length=30 ! \
  video/x-h264,profile=high ! \
  rtph264pay ! \
  udpsink host=<YOUR-LAPTOP-IP> port=5000 sync=false
```

On your laptop:
```bash
gst-launch-1.0 udpsrc port=5000 \
  caps="application/x-rtp,media=video,clock-rate=90000,encoding-name=H264,payload=96" ! \
  rtph264depay ! h264parse ! decodebin ! autovideosink sync=false
```

**Option 2 — Local DP display (if you have a monitor on the KV260's DisplayPort):**
```bash
gst-launch-1.0 v4l2src device=/dev/video2 ! \
  video/x-raw,width=1280,height=720,framerate=30/1 ! \
  videoconvert ! queue ! \
  kmssink connector-id=45 plane-id=39 sync=false
```

---

## Step 3: Adding AI Inference (Face Detection with DPU)

To get actual AI bounding boxes with your VVAS/DPU overlay, you need the `smart_model_select` pipeline. Inside your `xmutil-app` container:

```bash
# Make sure kv260-vvas-sms overlay is loaded first
xmutil loadapp kv260-vvas-sms

# Source VVAS environment
source /opt/xilinx/kv260-vvas-sms/app/setup.sh

# Run smart_model_select
cd /opt/xilinx/kv260-vvas-sms/app/
./smart_model_select
# Then enter: 1,1,2,0   (resnet model, fakesink output, DPU on)
```

> [!IMPORTANT]
> The `smart_model_select` binary reads from the MIPI pipeline by default. To use the USB camera you need to modify `setup.sh` or the GStreamer pipeline to swap `mediasrcbin` for `v4l2src device=/dev/videoX`.

---

## 🔍 Troubleshooting

| Symptom | Fix |
|:---|:---|
| `/dev/videoX` not found | Replug USB, check `dmesg | grep -i video` |
| `xmutil loadapp` fails | Run `xmutil unloadapp` first, check `dfx-mgrd` |
| `smartcam --usb` fails | Wrong device ID — try `--usb 0`, `--usb 2`, etc. |
| `omxh264enc` not found | VCU overlay not loaded, or using wrong container |
| RTSP stream laggy | Use `control-rate=low-latency` and reduce bitrate |
| Resolution rejected | C270 max is 1280×720 — do NOT use 1920×1080 |

### Confirm the C270 USB Device Number

```bash
# Run on KV260 — shows all V4L2 devices and their names
v4l2-ctl --list-devices

# Expected output like:
# HD Pro Webcam C270 (usb-...):
#         /dev/video2
#         /dev/video3
```

Use `/dev/video2` → `--usb 2` in the `smartcam` command.

---

## 📋 Quick Reference

| Goal | Command |
|:---|:---|
| Detect camera | `v4l2-ctl --list-devices` |
| Load overlay | `xmutil unloadapp && xmutil loadapp kv260-smartcam` |
| Start RTSP stream | `smartcam --usb 2 -W 1280 -H 720 -r 30 --target rtsp --aitask facedetect` |
| View RTSP on laptop | `ffplay rtsp://192.168.123.117:5000/test` |
| Raw GStreamer preview | `gst-launch-1.0 v4l2src device=/dev/video2 ! ...` |

> [!NOTE]
> The C270 is a 720p webcam. The Xilinx smartcam docs explicitly note: **"You must ensure the width/height/framerate defined are supported by your USB camera."** Always use `-W 1280 -H 720 -r 30` for the C270.
