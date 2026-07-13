# KV260 Smartcam Deployment Guide
## Stock Kria Ubuntu 22.04 + `xilinx/smartcam:2022.1`

Based on https://xilinx.github.io/kria-apps-docs/kv260/2022.1/linux_boot/ubuntu_22_04/build/html/docs/intro.html
> Compiled from the actual deployment session on the KV260 (June 2026).  
> Includes every command, real terminal output, and troubleshooting fix encountered during the live session.  
> Board IP confirmed: `192.168.123.118` | Dev PC IP: `192.168.123.128`

---

## Time Estimate

Before starting, here's a realistic breakdown of how long each stage takes:

| Stage | Time |
|---|---|
| SD card flash + first Linux boot | ~15–30 min |
| Hardware connections setup | ~5–10 min |
| Firmware download + xmutil load | ~10–20 min |
| Docker install + image pull | ~10–30 min |
| (Optional) Video file transcoding | ~10–20 min |
| Running the application | ~10–15 min |
| **Total (smooth run)** | **~1 to 1.5 hours** |
| **Total (first time, troubleshooting)** | **~2–3 hours** |

The biggest wildcards are **Docker image pull speed** (network) and **first-time Linux boot** (SD card prep). If you've booted the KV260 before, you can shave 30+ minutes off.

---

## Part 1 — Prepare the Dev PC

### Install ffmpeg (for receiving RTSP streams)

You need `ffplay` on your dev PC to receive and display the camera stream from the board.

**Ubuntu/Debian (including Ubuntu 24.04 dev PC):**
```bash
sudo apt update && sudo apt install ffmpeg
```

**Fedora:**
```bash
sudo dnf install ffmpeg
```

**Arch Linux:**
```bash
sudo pacman -S ffmpeg
```

Verify it installed:
```bash
ffmpeg -version
```

---

## Part 2 — Flash the SD Card

### Step 1 — Download the Ubuntu 22.04 Kria Image

Download the **Kria Ubuntu 22.04 LTS** image from:
> https://ubuntu.com/download/amd#kria-k26

> **Important:** Download Ubuntu **22.04**, not 24.04. The `xilinx/smartcam:2022.1` container targets 22.04 specifically.

The downloaded file will be named something like:
```
iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz
```

### Step 2 — Choose a Flashing Tool

| Tool | Platform | Notes |
|---|---|---|
| Raspberry Pi Imager | Any OS (recommended) | Handles `.xz` decompression automatically |
| Win32 Disk Imager | Windows only | Requires manual `.xz` extraction first |
| `dd` CLI | Linux/macOS | Fastest, but requires care — wrong device = data loss |

**Install Raspberry Pi Imager on Ubuntu 24.04:**
```bash
sudo apt install rpi-imager
```

Or download the `.deb` directly from https://www.raspberrypi.com/software/

### Step 3 — Flash the Image

#### Using Raspberry Pi Imager (recommended):
1. Open `rpi-imager`
2. Click **"Choose OS"** → **"Use custom"** → select the downloaded `.img.xz` file
3. Click **"Choose Storage"** → select your microSD card
4. Click **"Write"** and wait (~5–15 minutes depending on card speed)

#### Using `dd` on Ubuntu (command line):

> ⚠️ **Critical:** Always run `lsblk` first to confirm your SD card device name. Writing to the wrong device will silently wipe it.

```bash
# Identify your SD card device first
lsblk
```

**The image file is `.xz` compressed — do NOT pass it directly to `dd`:**
```bash
# WRONG — this will NOT work:
sudo dd if=iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz of=/dev/sda bs=4M status=progress conv=fsync
```

**Option A — Decompress first, then flash (safer, needs disk space):**
```bash
unxz /home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz

sudo dd if=/home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img \
  of=/dev/sda bs=4M status=progress conv=fsync
```

**Option B — Decompress and flash in one pipeline (saves disk space):**
```bash
xzcat /home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz \
  | sudo dd of=/dev/sda bs=4M status=progress conv=fsync
```

After flashing completes, run `sync` and remove the card safely:
```bash
sync
```

### SD Card Tips
- Use **at least 16GB** microSD (32GB+ recommended to leave room for Docker images)
- The KV260 boots from **QSPI first** (factory pre-flashed), then loads the OS from the microSD — do not touch the QSPI
- Flashing typically takes **5–15 minutes** depending on card speed

---

## Part 3 — Connect to the Board via UART

Insert the flashed SD card into the KV260 carrier card slot, then power it on.

**Do not use the GNOME desktop for this workflow** — connect via UART serial terminal instead.

### Physical Connection

- Use a **Micro-USB cable** plugged into **port J4** on the KV260 carrier card (the UART/debug port — not the USB-A ports)
- This creates 4 serial ports on your PC: `ttyUSB0`, `ttyUSB1`, `ttyUSB2`, `ttyUSB3`

### Connecting with PuTTY

The KV260 main console is on **ttyUSB1** (not ttyUSB0):

```bash
sudo putty /dev/ttyUSB1 -serial -sercfg 115200,8,n,1,N
```

Settings: **115200 baud, 8 data bits, no parity, 1 stop bit, no flow control**

### Troubleshooting: PuTTY Window Empty / Unresponsive

If the PuTTY window opens but shows nothing:

1. **Press Enter a few times** — if the board already booted, it may be waiting silently for input
2. **Power cycle the board** (unplug + replug power) while PuTTY is open — boot messages should scroll
3. **Try all ports** to find the right one:
   ```bash
   sudo screen /dev/ttyUSB0 115200
   sudo screen /dev/ttyUSB1 115200
   sudo screen /dev/ttyUSB2 115200
   sudo screen /dev/ttyUSB3 115200
   ```
   Press `Ctrl+A` then `K` to exit `screen`. The port that shows a login prompt or boot messages is the correct one.
4. **Permission issue** — add yourself to the `dialout` group:
   ```bash
   sudo usermod -aG dialout $USER
   ```
   Then log out and back in.

**Confirmed working in this session: `ttyUSB1`**

---

## Part 4 — First Login

At the `kria login:` prompt:

> **Do NOT log in as `root`** — root login is disabled by default on the Kria Ubuntu image.

**Default credentials:**
```
username: ubuntu
password: ubuntu
```

```
kria login: ubuntu
Password: ubuntu
```

On first login, Ubuntu will **force a password change**:
1. Enter current password: `ubuntu`
2. Enter new password (choose one)
3. Confirm new password

After that you'll have a shell with full `sudo` access.

---

## Part 5 — Add the Xilinx APT Repository

The `xlnx-firmware-kv260-smartcam` package is not in the standard Ubuntu repos. You need to add AMD/Xilinx's PPA first.

**What you'll see if the repo is missing:**
```
ubuntu@kria:~$ sudo apt install xlnx-firmware-kv260-smartcam
E: Unable to locate package xlnx-firmware-kv260-smartcam
```

Internet connectivity is not the issue (verify with `ping google.com`) — the Xilinx repo just isn't configured yet.

### Add the Xilinx PPA

**Method 1 — PPA (simplest):**
```bash
sudo add-apt-repository ppa:xilinx-apps/ppa
sudo apt update
```

**Method 2 — Manual repo entry (if PPA method fails):**
```bash
sudo curl -fsSL https://packages.xilinx.com/artifactory/debian/dists/jammy/Release.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/xilinx.gpg

echo "deb [signed-by=/usr/share/keyrings/xilinx.gpg] https://packages.xilinx.com/artifactory/debian jammy main" \
  | sudo tee /etc/apt/sources.list.d/xilinx.list

sudo apt update
```

**Verify the repo is working (lists all AMD/Xilinx packages available):**
```bash
apt-cache search xlnx
```

---

## Part 6 — Install Smartcam Firmware

```bash
sudo apt install xlnx-firmware-kv260-smartcam
```

**Expected output (package already included in newer Kria images):**
```
xlnx-firmware-kv260-smartcam is already the newest version (0.12-0xlnx2).
0 upgraded, 0 newly installed, 0 to remove and 550 not upgraded.
```

If it shows "already the newest version", the firmware is already bundled in your image — no further action needed.

---

## Part 7 — Load the FPGA Overlay

```bash
# Disable the desktop compositor to free GPU/PL resources
sudo xmutil desktop_disable

# Verify smartcam overlay is available
sudo xmutil listapps
```

**Expected output of `xmutil listapps`:**
```
                 Accelerator          Accel_type                            Base           Base_type      #slots(PL+AIE)         Active_slot
            k26-starter-kits            XRT_FLAT                k26-starter-kits            XRT_FLAT               (0+0)                  0,
              kv260-smartcam            XRT_FLAT                  kv260-smartcam            XRT_FLAT               (0+0)                  -1
```

```bash
# Unload whatever is currently in the slot
sudo xmutil unloadapp

# Load the smartcam overlay
sudo xmutil loadapp kv260-smartcam
```

### Expected Output + What It Means

```
[  942.013161] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/firmware-name
[  942.023353] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/resets
kv260-smartcam: loaded to slot 0
ubuntu@kria:~$ [  942.240692] zocl-drm axi:zyxclmm_drm: IRQ index 8 not found
[  942.286114] debugfs: Directory '4-003c' with parent 'regmap' already present!
```

**The terminal is NOT stuck.** These are kernel debug logs printing over your prompt. The overlay loaded successfully — note `kv260-smartcam: loaded to slot 0`.

All three warnings are **normal and harmless** on the KV260:
- `memory leak will occur if overlay removed` — expected device tree overlay warning on Kria
- `IRQ index 8 not found` — known benign message on KV260
- `debugfs: Directory already present` — benign, happens when the CSI/ISP subsystem is already registered

**Press Enter** to get your prompt back. You are ready to proceed.

---

## Part 8 — Install Docker

Docker is not pre-installed on the stock Kria Ubuntu image. If you try to run `docker pull` and see:
```
Command 'docker' not found, but can be installed with:
sudo snap install docker
sudo apt  install docker.io
```

Install it via `apt` (not snap — snap version can have permission issues with hardware access):

```bash
# Install Docker
sudo apt install docker.io -y

# Start Docker and enable it to start on boot
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group (avoids needing sudo for every docker command)
sudo usermod -aG docker $USER

# Apply the group change in the current session (no need to log out)
newgrp docker

# Verify Docker is working
docker --version
```

---

## Part 9 — Pull the Smartcam Docker Image

```bash
docker pull xilinx/smartcam:2022.1
```

> This image is several GB. Pull time depends on your network speed — allow 10–30 minutes.

---

## Part 10 — Get the Board IP Address

You need the board's IP to receive the RTSP stream on your dev PC.

```bash
ip addr show eth0
```

**Actual output from this session:**
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0a:35:0a:80:e1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.123.118/24 brd 192.168.123.255 scope global dynamic noprefixroute eth0
       valid_lft 6585sec preferred_lft 6585sec
    inet6 fe80::d895:c412:29cf:b8fe/64 scope link noprefixroute
```

**Board IP: `192.168.123.118`**

The dev PC is on `192.168.123.128` (same `/24` subnet) — RTSP will work.

> If your PC is on a different subnet, connect it to the same router/switch as the KV260 and verify with `ip addr show` on the PC.

---

## Part 11 — Launch the Docker Container

```bash
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

**Expected startup banner:**
```
==========================================
 _  __     _         ____   ___  __  __
| |/ /_ __(_) __ _  / ___| / _ \|  \/  |
| ' /|  __| |/ _  | \___ \| | | | |\/| |
| . \| |  | | (_| |  ___) | |_| | |  | |
|_|\_\_|  |_|\__ _| |____/ \___/|_|  |_|
==========================================
Build Date: 2022/09/26 15:21
root@xlnx-docker:/#
```

You are now inside the container at the `root@xlnx-docker:/# ` prompt.

---

## Part 12 — Run the Smartcam Application

### Application Modes

#### USB Webcam → RTSP Stream (confirmed working in this session)

> **Note on resolution:** Your USB webcam must support the requested resolution. `1920x1080` is often NOT supported by basic webcams. See the troubleshooting section below.

**Recommended: 640x480 at 30fps (smoothest for face detection demos):**
```bash
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
```

**Alternative: 1280x720 at 7.5fps (higher resolution, slower motion):**
```bash
smartcam --usb 1 -W 1280 -H 720 -r 7 --target rtsp
```

#### USB Webcam → Monitor Display
```bash
smartcam --usb 1 -W 640 -H 480 -r 30 --target dp
```

#### MIPI/CSI Camera (AR1335) → RTSP Stream
```bash
bash 01.mipi-rtsp.sh
```

#### MIPI/CSI Camera → Monitor Display
```bash
bash 02.mipi-dp.sh
```

#### From a Video File (no camera required)

First, transcode your video to the required format on your dev PC:
```bash
ffmpeg -i input-video.mp4 -c:v libx264 -pix_fmt nv12 -vf scale=1920:1080 -r 30 output.nv12.h264
```

Then SCP it to the board and run:
```bash
bash 03.file-file.sh /tmp/output.nv12.h264
```

### Confirmed Working Output (USB webcam, 640x480, RTSP)

```
root@xlnx-docker:/# smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 09:00:38.832: g_param_spec_float: ...
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 09:00:38.832: validate_pspec_to_install: ...
stream ready at:
 rtsp://172.17.0.1:554/test
rtsp://192.168.123.118:554/test
```

The `GLib-GObject-CRITICAL` warnings are **harmless** — the stream is running. `rtsp://192.168.123.118:554/test` is the address to use.

---

## Part 13 — Receive the Stream on the Dev PC

```bash
ffplay rtsp://192.168.123.118:554/test
```

> **Port gotcha:** The RTSP port is **554**, not 5000. The docs and some examples say 5000, but the actual container uses 554. Confirmed from the `stream ready at:` output above.

You should see a window open with the live webcam feed and **blue bounding boxes around detected faces** in real time.

### What to Expect

| Mode | Visual output |
|---|---|
| Face detection | Blue bounding boxes around detected faces, tracking in real time |
| ADAS SSD mode | Bounding boxes around vehicles on a road |

---

## Part 14 — Stopping and Restoring

**Stop the application:** `Ctrl+C` inside the container

**Re-enable the desktop** (after `xmutil desktop_disable`):
```bash
sudo xmutil desktop_enable
```

**Exit the container:**
```bash
exit
```

---

## Troubleshooting Reference

### USB Webcam: Resolution Not Supported

**Error:**
```
Error: USB camera doesn't support resolution 1920x1080
```

The smartcam app lists all supported resolutions when it fails. The webcam used in this session supported:

| Resolution | Max FPS |
|---|---|
| 640×480 | 30 fps |
| 640×360 | 30 fps |
| 320×240 | 30 fps |
| 160×120 | 30 fps |
| 176×144 | 30 fps |
| 320×176 | 30 fps |
| 352×288 | 30 fps |
| 432×240 | 30 fps |
| 544×288 | 30 fps |
| 752×416 | 25 fps |
| 800×448 | 20 fps |
| 800×600 | 20 fps |
| 864×480 | 20 fps |
| 960×544 | 15 fps |
| 960×720 | 10 fps |
| 1024×576 | 10 fps |
| 1184×656 | 10 fps |
| 1280×720 | 7.5 fps |
| 1280×960 | 7.5 fps |

**Solution:** Use `640x480 at 30fps` for the best face-detection experience (smooth motion is more important than resolution for real-time AI tracking):
```bash
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
```

---

### `xlnx-firmware-kv260-smartcam` Not Found

The Xilinx APT repo is not configured. Add it:
```bash
sudo add-apt-repository ppa:xilinx-apps/ppa
sudo apt update
sudo apt install xlnx-firmware-kv260-smartcam
```

---

### `docker` Command Not Found

Docker is not pre-installed. Install it:
```bash
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

---

### UART Terminal Empty / Unresponsive

1. Make sure the Micro-USB cable is in **port J4** (not the USB-A ports)
2. Try **ttyUSB1** — that is the confirmed working port on KV260
3. Press **Enter** a few times — may already be booted and waiting
4. **Power cycle** the board while the terminal is open
5. Quick-test all ports with `screen /dev/ttyUSBx 115200`

---

### Stream Port: Use 554, Not 5000

Despite what some documentation says, the actual RTSP port used by the `xilinx/smartcam:2022.1` container is **554**. Confirm from the container output:
```
stream ready at:
 rtsp://172.17.0.1:554/test
rtsp://192.168.123.118:554/test
```

Always use port **554** on the dev PC:
```bash
ffplay rtsp://192.168.123.118:554/test
```

---

### Kernel Debug Messages After `xmutil loadapp`

The terminal appearing "stuck" with kernel log output after `xmutil loadapp kv260-smartcam` is **normal**. Press Enter to get your prompt back. The important line is:
```
kv260-smartcam: loaded to slot 0
```
All other warnings (`memory leak`, `IRQ index 8`, `debugfs: Directory already present`) are expected and harmless on KV260.

---

## Quick Reference: Full Command Sequence

```bash
# --- On KV260 board (via UART ttyUSB1) ---

# 1. Add Xilinx repo (if needed)
sudo add-apt-repository ppa:xilinx-apps/ppa && sudo apt update

# 2. Install firmware (may already be present)
sudo apt install xlnx-firmware-kv260-smartcam

# 3. Install Docker (if not present)
sudo apt install docker.io -y
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker $USER && newgrp docker

# 4. Load overlay
sudo xmutil desktop_disable
sudo xmutil unloadapp
sudo xmutil loadapp kv260-smartcam
# Press Enter after kernel messages

# 5. Pull Docker image (once, ~several GB)
docker pull xilinx/smartcam:2022.1

# 6. Launch container
docker run --env="DISPLAY" -h "xlnx-docker" --env="XDG_SESSION_TYPE" \
  --net=host --privileged \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v /tmp:/tmp -v /dev:/dev -v /sys:/sys \
  -v /etc/vart.conf:/etc/vart.conf \
  -v /lib/firmware/xilinx:/lib/firmware/xilinx -v /run:/run \
  -it xilinx/smartcam:2022.1 bash

# 7. Inside the container — run face detection
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp

# --- On dev PC (Ubuntu 24.04, IP 192.168.123.128) ---

# Receive and display the stream
ffplay rtsp://192.168.123.118:554/test
```

---

## Environment Details (This Session)

| Item | Value |
|---|---|
| Board | Xilinx Kria KV260 |
| Board OS | Ubuntu 22.04 LTS (Kria classic desktop image) |
| Board IP | `192.168.123.118` |
| Dev PC OS | Ubuntu 24.04 |
| Dev PC IP | `192.168.123.128` |
| UART port | `/dev/ttyUSB1` at 115200 baud |
| Firmware version | `xlnx-firmware-kv260-smartcam 0.12-0xlnx2` |
| Container | `xilinx/smartcam:2022.1` (Build Date: 2022/09/26) |
| Camera used | USB webcam (Logitech C270 or similar), max 640×480 @ 30fps |
| RTSP port | `554` (not 5000) |
| RTSP URL | `rtsp://192.168.123.118:554/test` |
