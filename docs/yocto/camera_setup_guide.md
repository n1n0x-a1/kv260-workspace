# KV260 Camera Setup Guide — CSI (AR1335/AP1302) vs USB (Logitech C270)

> **TL;DR: Use the CSI camera (AR1335 + AP1302 ISP module on the `IAS 0` connector). It works end-to-end as of this guide.
> The USB webcam (Logitech C270) path is a confirmed kernel-level dead end on this board's current image — do not retry it without a kernel fix.**

This supersedes `usb_webcam_quickstart.md` and `camera_research_guide.md`. Those files contained theories that were never validated against this board's actual behavior (notably the `usb5744` hub-reset theory and the "no kernel rebuild required" claim) — everything below was confirmed live, on this exact board/image, through direct debugging.

---

## 1. Hardware

- **CSI camera module**: ON Semiconductor **AR1335** sensor (13MP, Bayer `SGRBG10`, native `4208x3120`) behind an **AP1302** ISP bridge chip (handles demosaic/scaling/YUV conversion). This is the module that ships in the Kria KV260 Vision AI Starter Kit, connected via the **`IAS 0` (`J10`)** FPC connector next to the 12V barrel jack.
  - Alternate connectors: `IAS 1` (`J9`), Raspberry Pi camera header (`J11`).
- **USB webcam**: Logitech C270, UVC-compliant, tested and **confirmed working when plugged into a regular PC** — the hardware itself is fine. The problem is entirely on the KV260's kernel/USB-controller side (see §3).

---

## 2. CSI Camera (AR1335 + AP1302) — Working Setup

### 2.1 Why this needed work in the first place

The kernel (`6.6.40-xilinx`, built via `yocto-xilinx/kv260-yocto`) had `CONFIG_VIDEO_AP1302` **disabled** (`# CONFIG_VIDEO_AP1302 is not set`), even though all the surrounding Xilinx CSI2RX/ISP infrastructure was built in (`CONFIG_VIDEO_XILINX=y`, `CONFIG_VIDEO_XILINX_CSI2RXSS=y`, `CONFIG_VIDEO_XILINX_ISP=y`, etc.). Without the AP1302 driver, the sensor's I2C device (`4-003c`) was declared in the device tree but had no driver bound, and the CSI/ISP pipeline never produced any video device.

### 2.2 Build the AP1302 driver as a kernel module

Built as a loadable module (not baked into the main `Image`) so no full kernel/`Image` redeploy is needed — only the running kernel needs a matching `insmod`.

```bash
cd yocto-xilinx/kv260-yocto/poky/build

# Enable the driver
bitbake linux-xlnx -c menuconfig
#   Press '/', search "VIDEO_AP1302", jump to it, press 'M', save & exit

# Verify it actually stuck BEFORE compiling (menuconfig saves can silently fail)
grep AP1302 tmp/work/zynqmp_generic-xilinx-linux/linux-xlnx/6.6.40+git/linux-zynqmp_generic-standard-build/.config
# Expect: CONFIG_VIDEO_AP1302=m

# IMPORTANT: kernel modules are a SEPARATE bitbake task from the main kernel image.
# `-c compile` alone does NOT build modules on this recipe.
bitbake linux-xlnx -c compile_kernelmodules

# Resulting module:
find tmp/work/zynqmp_generic-xilinx-linux/linux-xlnx -name "ap1302.ko"
# .../drivers/media/i2c/ap1302.ko
```

### 2.3 Get the AP1302 firmware blob

The AP1302 is itself a small embedded processor — it requires a firmware blob uploaded to it at runtime via `request_firmware()`. Without it, probe fails with:
```
ap1302 4-003c: Direct firmware load for ap1302_ar1335_single_fw.bin failed with error -2
```

This repo already has a (currently unported-to-Yocto) PetaLinux recipe referencing it at:
`smartapp-modified/kv260-smartapp-platform/change/petalinux_new/meta-user/recipes-firmware/ap1302-firmware/`

Fetch it directly from the pinned upstream commit:
```bash
git clone --branch xlnx_rel_v2022.1 https://github.com/Xilinx/ap1302-firmware.git
# pinned commit: 63e20752dc8b1e91fc6d6d518ebeb76f65e9f738
# file needed: ap1302_ar1335_single_fw.bin (there's also an ar0144 variant in the same repo — wrong sensor, don't use it)
```

Copy it to the board (this **does** persist across reboots — `/lib/firmware` is on rootfs, unlike `/tmp`):
```bash
scp ap1302-firmware/ap1302_ar1335_single_fw.bin root@192.168.123.117:/lib/firmware/
```

### 2.4 Per-boot startup sequence (currently manual — nothing below persists across reboot except the firmware file)

```bash
# 1. Load the FPGA accelerator slot that adds the CSI/ISP device-tree overlay
#    (this is what creates the I2C mux buses 4-7, the isp_vcap_csi device, and the
#    ap1302 I2C device node at 4-003c — none of this exists before this runs)
xmutil loadapp kv260-smartcam

# 2. Copy and load the AP1302 module (re-copy each boot — /tmp is wiped on reboot)
scp tmp/work/zynqmp_generic-xilinx-linux/linux-xlnx/6.6.40+git/linux-zynqmp_generic-standard-build/drivers/media/i2c/ap1302.ko root@192.168.123.117:/tmp/
ssh root@192.168.123.117 "insmod /tmp/ap1302.ko"

# 3. Verify the probe succeeded
ssh root@192.168.123.117 "dmesg | tail -n 20; readlink /sys/bus/i2c/devices/4-003c/driver"
# Expect: "ap1302 4-003c: AP1302 revision 0.2.6 detected" and the readlink resolving to .../drivers/ap1302
# A "CRC mismatch" dev_warn followed by a second "revision detected" line is benign — the driver retries
# internally (returns -EAGAIN) and succeeds on retry.
```

> **Gotcha**: if `insmod` fails with error `-17` (`EEXIST`), it's almost always stale kernel state (e.g. a leftover `debugfs` directory) from a previous failed probe attempt on the same boot. Don't try to clean it up by hand — `rmmod`, fix whatever was wrong (e.g. missing firmware), and `insmod` again; if it still fails with `-17`, do a full `reboot` and retry from step 1.

> **Gotcha**: vermagic must match exactly. Check with:
> ```bash
> modinfo /tmp/ap1302.ko | grep vermagic
> uname -r
> ```
> Both must read identically (e.g. `6.6.40-xilinx-g2b7f6f70a62a SMP mod_unload aarch64`). This holds as long as you're building from the same kernel source tree already deployed — no other config/kernel changes in between.

### 2.5 Which container to use

Containerized via `containerd`/`ctr` (not plain Docker). Different pods have different `/dev` visibility:

- **`xmutil-app` pod**: has `xmutil` CLI and kernel/sysfs access (good for steps 2.4.1–2.4.3 above), but **no `/dev/video*` nodes** — don't bother testing capture from here.
- **`camera-app` pod** (two containers — try the non-pause one first): has `/dev/video*`, `v4l2-ctl`, `gst-launch-1.0`, `media-ctl` — use this for everything in §2.6 onward.

Find the right container after any reboot (IDs change every restart):
```bash
ctr -n k8s.io tasks ls | grep RUNNING
ctr -n k8s.io c info <container-id> | grep "pod.name"
ctr -n k8s.io tasks exec --exec-id mytest -t <container-id> sh
```

Inside `camera-app`, the CSI capture node usually shows up as `/dev/video0` (it's the only video device visible in that pod's namespace — no USB competing for numbering).

### 2.6 Fix the media pipeline links before streaming

`v4l2-ctl -d /dev/video0 --get-fmt-video` will initially show `Height: 0` (invalid) — the pipeline's format hasn't been negotiated yet. Check topology:

```bash
media-ctl -p
```

Pipeline: `ar1335 0` (sensor) → `ap1302.4-003c` (ISP) → `80000000.csiss` (Xilinx CSI2RX subsystem) → `isp_vcap_csi output 0` (`/dev/video0`).

**Key finding**: the `csiss` entity's pad format is **fixed by FPGA synthesis**, not runtime-configurable. This particular `kv260-smartcam` bitstream only accepts `MIPI_CSI2_DT_YUV420_8B` (mbus code `MEDIA_BUS_FMT_VYYUYY8_1X24`) at `1920x1080` — confirmed in `drivers/media/platform/xilinx/xilinx-csi2rxss.c`, which uses the kernel's **strict default** `v4l2_subdev_link_validate` (exact code+resolution match required across every link, or `VIDIOC_STREAMON` fails silently with `-EPIPE`/"Broken pipe" and **zero dmesg output** — that silence is itself diagnostic of a link-validation failure, not a driver crash).

`ap1302`'s source pad defaults to `UYVY8_1X16` at the sensor's native `4208x3120` (i.e. ISP passthrough, unscaled) — this needs to be explicitly changed to match `csiss`. Good news: `ap1302` does support `VYYUYY8_1X24` directly (see `supported_video_formats[]` in `ap1302.c`), so no resolution-mismatch workaround is needed — just set the right format:

```bash
# Set ap1302's ISP output to match what the FPGA's CSI2RX block expects
media-ctl -V '"ap1302.4-003c":2 [fmt:VYYUYY8_1X24/1920x1080]'

# Confirm both ends of the ap1302 -> csiss link now match exactly
media-ctl -p
```

Then set the actual V4L2 capture format (the memory-side format, post any internal AXI conversion — independent of the subdev mbus codes above):

```bash
v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=NV12
```

### 2.7 Capture test (confirmed working)

```bash
rm -f /tmp/csi_test.raw
v4l2-ctl -d /dev/video0 --stream-mmap --stream-count=3 --stream-to=/tmp/csi_test.raw
ls -la /tmp/csi_test.raw
# Expect exactly 9,331,200 bytes = 1920*1080*1.5 (NV12) * 3 frames — confirms valid, correctly-sized frames
```

Verify visually (from your dev machine, after `scp`-ing the file off the board):
```bash
ffmpeg -y -f rawvideo -pixel_format nv12 -video_size 1920x1080 -i csi_test.raw -frames:v 1 -update 1 frame1.png
```

**Known cosmetic issue**: captured image has an orange/red color cast. Not yet root-caused — likely an NV12/NV21 chroma-plane order mismatch, or AP1302 auto-white-balance not converged. Try `pixelformat=NV21` as a first thing to test if revisiting this.

### 2.8 Live network streaming (software JPEG — VCU H.264 is broken, see §4)

On the board, inside the `camera-app` container:
```bash
gst-launch-1.0 v4l2src device=/dev/video0 ! \
  video/x-raw,format=NV12,width=1920,height=1080,framerate=30/1 ! \
  videoconvert ! jpegenc ! rtpjpegpay ! \
  udpsink host=<your-laptop-ip> port=5000 sync=false
```

On your laptop:
```bash
gst-launch-1.0 udpsrc port=5000 \
  caps="application/x-rtp,media=video,clock-rate=90000,encoding-name=JPEG,payload=26" ! \
  rtpjpegdepay ! jpegdec ! autovideosink sync=false
```

(Or use a `stream.sdp` file + `ffplay -protocol_whitelist file,udp,rtp -i stream.sdp` — same RTP/JPEG caps as above.)

### 2.9 Untested alternative: `mediasrcbin`

Xilinx's own `mediasrcbin` GStreamer element wraps the v4l2/media-ctl plumbing above automatically (used in the official Vitis-AI/VVAS reference pipelines, e.g.):
```bash
gst-launch-1.0 mediasrcbin media-device=/dev/media1 ! \
  'video/x-raw, width=1920, height=1080, format=NV12, framerate=30/1' ! \
  queue ! kmssink connector-id=45 plane-id=39 sync=false
```
This was **not tested** in this debugging session (we validated the manual `v4l2src` + `media-ctl` path instead). If it's available in the `camera-app` container, it may avoid needing the manual `media-ctl -V` step in §2.6 — worth trying as a cleanup later. Display output via `kmssink`/`modetest` (local DP/HDMI monitor) is similarly from the original research doc and **untested** — `modetest -M xlnx` to find connector/CRTC/plane IDs first.

### 2.10 Not yet done / follow-ups

- **Nothing in §2.4 persists across reboot** except the firmware file. Would need a systemd service or init script to run `xmutil loadapp`, `insmod`, and the `media-ctl -V` fixup automatically on boot.
- `CONFIG_VIDEO_AP1302=m` currently only lives in the live build's `.config` (set via `menuconfig`). Should become a proper kernel config fragment in a `meta-*` layer (e.g. a `.bbappend` for the kernel recipe) so it survives a clean rebuild.
- Color cast (§2.7) not root-caused.

---

## 3. USB Webcam (Logitech C270) — Confirmed Dead End

**Do not re-attempt this path with the same tactics below — all of them were tried and conclusively ruled out.**

The `uvcvideo` driver on this kernel successfully decodes complete, valid USB video frames internally — proven repeatedly via:
```bash
cat /sys/kernel/debug/usb/uvcvideo/*/stats
# frame counters climb steadily, 0 errors, across multiple independent test runs
```
But those completed buffers **never reach userspace**. `VIDIOC_DQBUF`/`poll()` just hangs forever, every time, 0 bytes out, regardless of:

- GStreamer (`v4l2src`) vs raw `v4l2-ctl --stream-mmap`
- `mmap` vs `userptr` buffer mode
- USB port/cable swap (tried — reset frequency got *worse*, not better)
- `uvcvideo` `quirks=128` (`FIX_BANDWIDTH`) module parameter, applied both hot and via a clean reboot + fresh probe (ruling out "stale leaked URB state" as the cause)
- A fully clean board reboot

The camera hardware itself is confirmed good — **tested working on a regular PC**. This is a genuine bug in the buffer-completion signaling path between `uvcvideo` and the V4L2 core (or a DMA cache-coherency issue) specific to this kernel/SoC/xHCI-controller combination — not a config/quirk/driver-state issue.

If USB webcam support is ever needed again: it would require either a different camera model (untested whether that dodges the bug) or an actual kernel patch/upgrade — not further config tuning. The `usb5744` hub-controller-module theory from the old `usb_webcam_quickstart.md` was **not** what we encountered in this session (our C270 was detected and enumerated fine via `lsusb`/`dmesg` throughout) — that may describe a different symptom (camera not detected at all) from an earlier/different session, not the buffer-delivery bug documented here.

---

## 4. VCU (Hardware H.264 Encoder) — Also Broken, Separate From the Camera Issue

Any GStreamer pipeline using `omxh264enc` fails with:
```
[omx_core.cpp:181] [OMX_GetHandle] Couldnt allocate dma allocator (tried using /dev/allegroIP)
ERROR: ... Could not initialize supporting library.
```
The Allegro VCU kernel driver isn't present in this image (`/dev/allegroIP` doesn't exist). This is unrelated to which camera you use — it affects **any** hardware H.264 encoding attempt on this board's current kernel build. Fixing it would need the Allegro/VCU driver added to the kernel build, similar in spirit to the AP1302 fix in §2.2, but not yet attempted.

**Workaround used throughout this guide**: encode in software instead — `jpegenc` for MJPEG-over-RTP (§2.8), which is far less CPU-efficient than hardware H.264 but works today with zero kernel changes.

---

## 5. Quick Reference

| Goal | Command |
|:---|:---|
| Check AP1302 driver bound | `readlink /sys/bus/i2c/devices/4-003c/driver` |
| Load CSI FPGA overlay | `xmutil loadapp kv260-smartcam` |
| Load AP1302 module | `insmod /tmp/ap1302.ko` |
| Fix ISP→CSI2RX format link | `media-ctl -V '"ap1302.4-003c":2 [fmt:VYYUYY8_1X24/1920x1080]'` |
| Set capture format | `v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=NV12` |
| Test capture | `v4l2-ctl -d /dev/video0 --stream-mmap --stream-count=3 --stream-to=/tmp/test.raw` |
| Check media topology | `media-ctl -p` |
| List apps/overlays | `xmutil listapps` |
| List V4L2 devices (per-container) | `v4l2-ctl --list-devices` |

| Symptom | Meaning |
|:---|:---|
| `VIDIOC_STREAMON` → `-EPIPE`, no dmesg output | Media pipeline link format mismatch — check `media-ctl -p`, fix with `-V` |
| `insmod` → error `-17` (EEXIST) | Stale state from a prior failed probe this boot — fix the real issue, retry; reboot if it persists |
| `ap1302` probe fails, "Direct firmware load ... failed with error -2" | Missing `/lib/firmware/ap1302_ar1335_single_fw.bin` |
| USB webcam: 0-byte capture, infinite hang, 0 errors in `uvcvideo` debugfs stats | The confirmed kernel bug from §3 — not fixable via config |
| `omxh264enc` fails, "Couldnt allocate dma allocator" | VCU driver missing — use `jpegenc` instead (§4) |
