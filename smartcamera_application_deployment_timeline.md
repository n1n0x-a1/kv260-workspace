# Conversation with Claude

## Human (Jun 18, 2026, 10:02 AM):

https://xilinx.github.io/kria-apps-docs/kv260/2022.1/build/html/docs/smartcamera/docs/app_deployment.html#run-the-application

how long will i need to go through this entire process?

---

## Claude:

Here's a realistic time estimate for each stage, assuming you're reasonably familiar with Linux and embedded systems:

**1. Booting Up Linux** — ~15–30 min
Flashing the SD card and doing the initial Linux boot, assuming you've done something similar before.

**2. Hardware Setup** — ~5–10 min
Connecting the monitor, IAS sensor or USB webcam, and verifying connections.

**3. Downloading & Loading Firmware** — ~10–20 min
Running `apt install`, `xmutil loadapp`, etc. Depends on your internet speed and whether any issues come up with switching accelerators.

**4. Docker Pull & Launch** — ~10–30 min
Pulling the `xilinx/smartcam:2022.1` image can take a while depending on bandwidth (~several GB). Launching the container itself is quick.

**5. (Optional) Video File Prep** — ~10–20 min
Downloading sample videos and transcoding them with `ffmpeg` to H264/NV12 format. Transcoding time depends on video length.

**6. Running the Application** — ~10–15 min
Whether via Jupyter Notebook or the CLI scripts, the actual launch is fast once everything is set up.

---

**Total estimate: ~1 to 1.5 hours** under smooth conditions, or **2–3 hours** if you're new to Kria/AMD embedded boards, run into SD card or Docker issues, or need to troubleshoot the MIPI sensor or display output.

The biggest wildcard is the **Docker image pull** (network speed) and **first-time Linux boot** (SD card prep). If you've already booted Linux on the KV260 before, you can shave off 30+ minutes.

---

## Human (Jun 18, 2026, 10:12 AM):

how do i install ffmpeg in linux

---

## Claude:

You can install FFmpeg with a single command depending on your distro:

**Ubuntu/Debian:**
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

After installing, verify it worked:
```bash
ffmpeg -version
```

Since you're working on the KV260 (Ubuntu 22.04), the first command is what you want. It's the same one the Xilinx docs reference for the client PC side to receive RTSP streams.

---

## Human (Jun 22, 2026, 3:44 PM):

https://xilinx.github.io/kria-apps-docs/kv260/2022.1/linux_boot/ubuntu_22_04/build/html/docs/sdcard.html

can you explaint the step by step process on how do i setup an sd card image

---

## Claude:

Here's the full breakdown based on the docs:

---

### Step 1 — Download the Ubuntu Image
Go to the [Kria Ubuntu 22.04 LTS Image](https://ubuntu.com/download/amd#kria-k26) page and download the image for the KV260. Save it on your computer.

> Make sure you pick **Ubuntu 22.04**, not 24.04, since the smartcam app targets 22.04.

---

### Step 2 — Download a Flashing Tool

Pick one based on your OS:

- **Any OS (recommended):** [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
- **Windows only (alternative):** Win32 Disk Imager

---

### Step 3 — Flash the Image to the microSD Card

**Using Raspberry Pi Imager:**
1. Open the app
2. Click **"Choose OS"** → select **"Use custom"** → pick the `.img` file you downloaded
3. Click **"Choose Storage"** → select your microSD card
4. Click **"Write"** and wait for it to finish

**Using Win32 Disk Imager (Windows):**
1. First **extract** the compressed image file (`.xz` or `.zip`) using 7-Zip or similar
2. Open Win32 Disk Imager
3. Click the **blue folder icon** and browse to the extracted `.img` file
4. From the **Device dropdown**, select your microSD card (double-check this — wrong device = data loss)
5. Click **"Write"** → confirm **"Yes"** → wait for it to complete

---

### Step 4 — Insert and Boot
Once flashing is done, insert the microSD into the **microSD slot on the KV260 carrier card**, then proceed to connect everything (Step 2 of the boot guide).

---

**Tips:**
- Use a **microSD card of at least 16GB** (32GB+ recommended to have room for Docker images)
- The KV260 boots from **QSPI first** (pre-flashed at factory), then loads the OS from the microSD — you don't need to touch the QSPI
- The whole flashing process typically takes **5–15 minutes** depending on your card speed

---

## Human (Jun 22, 2026, 3:44 PM):

https://xilinx.github.io/kria-apps-docs/kv260/2022.1/linux_boot/ubuntu_22_04/build/html/docs/sdcard.html

can you explaint the step by step process on how do i setup an sd card image

---

## Claude:

No problem at all — Raspberry Pi Imager works on Ubuntu 24.04. Just install it with:

```bash
sudo apt install rpi-imager
```

Or download it directly from the [Raspberry Pi website](https://www.raspberrypi.com/software/) and install the `.deb` file.

Then follow the same steps:
1. Open **rpi-imager**
2. Choose OS → **Use custom** → select the downloaded Kria Ubuntu 22.04 `.img` file
3. Choose Storage → select your microSD card
4. Click **Write**

---

**Alternatively**, if you prefer the command line, you can flash it directly with `dd`:

```bash
# First, find your SD card device name
lsblk

# Then flash (replace /dev/sdX with your actual card, e.g. /dev/sdb)
sudo dd if=kria-ubuntu-22.04.img of=/dev/sdX bs=4M status=progress conv=fsync
```

> ⚠️ Be very careful with `dd` — double-check the device name with `lsblk` before running. Writing to the wrong device will overwrite your data with no warning.

After `dd` finishes, run:
```bash
sync
```
Then safely remove the card.

Both methods work fine from Ubuntu 24.04. Raspberry Pi Imager is the safer/easier option if you're not fully comfortable with `dd`.

---

## Human (Jun 22, 2026, 3:51 PM):

what if my development PC is ubuntu 24.04?

---

## Claude:

Based on the docs we already fetched earlier, here's the full end-to-end process after flashing:

---

### Step 1 — Boot Linux on the KV260
Insert the flashed microSD into the KV260, power it on, and let it boot into Ubuntu 22.04. Connect via UART (recommended over GNOME desktop) using a serial terminal on your PC.

---

### Step 2 — Hardware Setup
Before or right after booting, make sure:
- A **1080p or 4K monitor** is connected via DP or HDMI
- Either an **AR1335 IAS sensor** is installed in port J7, **or** a **USB webcam** (e.g. Logitech BRIO) is plugged in
- Your PC and KV260 are on the **same network subnet** (needed for RTSP streaming)

---

### Step 3 — Install the Smartcam Firmware
On the KV260 terminal:
```bash
sudo apt search xlnx-firmware-kv260-smartcam   # verify it's available
sudo apt install xlnx-firmware-kv260-smartcam
```

---

### Step 4 — Load the Application
```bash
sudo xmutil desktop_disable     # frees up resources, monitor goes blank — use UART from here
sudo xmutil listapps            # verify smartcam appears
sudo xmutil unloadapp           # unload any currently active app
sudo xmutil loadapp kv260-smartcam
```

---

### Step 5 — Pull and Launch the Docker Container
```bash
docker pull xilinx/smartcam:2022.1   # this may take a while (~several GB)

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

You'll land at a `root@xlnx-docker/#` prompt inside the container.

---

### Step 6 — Run the Application

Pick the mode that matches your setup:

**MIPI camera → stream via RTSP to your PC:**
```bash
bash 01.mipi-rtsp.sh
```
Then on your **PC**, play the stream:
```bash
ffplay rtsp://<board-ip>:5000/test
```

**MIPI camera → display on connected monitor:**
```bash
bash 02.mipi-dp.sh
```

**USB webcam → RTSP stream:**
```bash
smartcam --usb 1 -W 1920 -H 1080 -r 30 --target rtsp
```

**USB webcam → monitor display:**
```bash
smartcam --usb 1 -W 1920 -H 1080 -r 30 --target dp
```

**From a video file (if no camera):**
```bash
# First transcode your MP4 to H264
ffmpeg -i input-video.mp4 -c:v libx264 -pix_fmt nv12 -vf scale=1920:1080 -r 30 output.nv12.h264

# Then run
bash 03.file-file.sh /tmp/output.nv12.h264
```

---

### What to Expect
- **Face detection mode:** blue bounding boxes appear around detected faces, tracking movement in real time
- **ADAS SSD mode:** vehicles on a highway get bounding boxes
- To stop the app at any time: `CTRL + C`
- To re-enable the desktop after you're done: `sudo xmutil desktop_enable`

---

**Quick tip on getting the board IP** (needed for RTSP):
```bash
ifconfig eth0
```
Look for the `inet` address — that's what you plug into the `ffplay` command on your PC.

---

## Human (Jun 22, 2026, 3:57 PM):

now how do i run the smartcam https://xilinx.github.io/kria-apps-docs/kv260/2022.1/build/html/docs/smartcamera/docs/app_deployment.html#run-the-application
after flashing the kv260

---

## Claude:

Almost, but there's one issue — **the file is still `.xz` compressed**. You can't flash a compressed image directly with `dd`.

You have two options:

---

### Option A — Decompress first, then flash (safer)
```bash
# Extract first
unxz /home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz

# Then flash the extracted .img
sudo dd if=/home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img of=/dev/sda bs=4M status=progress conv=fsync
```

---

### Option B — Decompress and flash in one command (saves disk space)
```bash
xzcat /home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz | sudo dd of=/dev/sda bs=4M status=progress conv=fsync
```

---

### ⚠️ Before running either — double check `/dev/sda` is actually your SD card:
```bash
lsblk
```
Make sure `/dev/sda` is your microSD and **not your system drive**. On many setups, `/dev/sda` is the main hard drive. Your SD card might be `/dev/sdb` or `/dev/mmcblk0`. Flashing to the wrong device will wipe it with no warning.

---

## Human (Jun 22, 2026, 4:08 PM):

sudo dd if=/home/syvesdh/Downloads/iot-limerick-kria-classic-desktop-2204-20240304-165.img.xz of=/dev/sda bs=4M status=progress conv=fsync

is this good

---

## Claude:

The KV260 UART uses **4 ports (ttyUSB0–3)**, and you need the right one. The issue is likely one of these:

---

### 1. Try ttyUSB1 instead (most common for KV260)
The KV260's main console is usually on the **second port**:
```bash
sudo putty /dev/ttyUSB1 -serial -sercfg 115200,8,n,1,N
```

---

### 2. If still blank — press Enter or reset the board
An empty PuTTY window is sometimes normal if the board is already booted and waiting. Just **press Enter** a few times in the PuTTY window to get a login prompt.

If nothing appears, **power cycle the KV260** (unplug and replug power) while PuTTY is open — you should see boot messages scroll through.

---

### 3. Check you have permission to access the port
```bash
sudo usermod -aG dialout $USER
```
Then **log out and back in**, and try without sudo:
```bash
putty /dev/ttyUSB1 -serial -sercfg 115200,8,n,1,N
```

---

### 4. Verify the cable is the right one
The KV260 requires a **Micro-USB cable plugged into port J4** (the UART/debug port, not the USB-A ports). Double check it's in J4 specifically.

---

**Quick test** — try all ports one by one:
```bash
sudo screen /dev/ttyUSB0 115200
sudo screen /dev/ttyUSB1 115200
sudo screen /dev/ttyUSB2 115200
sudo screen /dev/ttyUSB3 115200
```
Press `Ctrl+A` then `K` to exit screen. The one that shows boot output or a login prompt is the right port.

---

## Human (Jun 22, 2026, 4:34 PM):

the putty window is empty and not responsive

---

## Claude:

The default credentials for the Kria Ubuntu 22.04 image are **not** root. Try these:

---

**Default login:**
```
username: ubuntu
password: ubuntu
```

So at the `kria login:` prompt:
```
kria login: ubuntu
Password: ubuntu
```

---

On first login it will likely ask you to **change the password immediately** — just follow the prompts:
1. Enter current password: `ubuntu`
2. Enter new password: (choose one)
3. Confirm new password

After that you'll be dropped into the shell and can `sudo` freely since the `ubuntu` user has sudo privileges by default.

---

## Human (Jun 22, 2026, 4:38 PM):

okay ttyUSB1 worked 

Password: 
kria login: root
Password: 
Login incorrect
kria login:

---

## Claude:

The internet works fine, but the Xilinx/AMD package repository isn't configured yet. You need to add it first.

---

### Step 1 — Add the Xilinx PPA
```bash
sudo add-apt-repository ppa:xilinx-apps/ppa
```

If that doesn't work, add it manually:
```bash
sudo curl -fsSL https://packages.xilinx.com/artifactory/debian/dists/jammy/Release.gpg | sudo gpg --dearmor -o /usr/share/keyrings/xilinx.gpg

echo "deb [signed-by=/usr/share/keyrings/xilinx.gpg] https://packages.xilinx.com/artifactory/debian jammy main" | sudo tee /etc/apt/sources.list.d/xilinx.list
```

---

### Step 2 — Update package lists
```bash
sudo apt update
```

---

### Step 3 — Try installing again
```bash
sudo apt install xlnx-firmware-kv260-smartcam
```

---

If it still can't find it, check what Xilinx packages are actually available on your image:
```bash
apt-cache search xlnx
```
This will show all AMD/Xilinx packages currently visible to your system, which helps confirm if the repo was added correctly.

---

## Human (Jun 22, 2026, 4:42 PM):

ubuntu@kria:~$ sudo apt search xlnx-firmware-kv260-smartcam
[sudo] password for ubuntu: 
Sorting... Done
Full Text Search... Done
ubuntu@kria:~$ sudo apt install xlnx-firmware-kv260-smartcam
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
E: Unable to locate package xlnx-firmware-kv260-smartcam
ubuntu@kria:~$ ping google.com
PING google.com (142.250.198.78) 56(84) bytes of data.
64 bytes from lctsaa-ab-in-f14.1e100.net (142.250.198.78): icmp_seq=1 ttl=115 time=8.28 ms
64 bytes from lctsaa-ab-in-f14.1e100.net (142.250.198.78): icmp_seq=2 ttl=115 time=11.8 ms
64 bytes from lctsaa-ab-in-f14.1e100.net (142.250.198.78): icmp_seq=3 ttl=115 time=5.78 ms
^C
--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 5.775/8.604/11.760/2.454 ms
ubuntu@kria:~$

---

## Claude:

Yes, it's completely fine! Those messages are just **kernel debug logs** printing to your terminal — the app loaded successfully. Notice it already said:

```
kv260-smartcam: loaded to slot 0
```

The warnings you see are normal and non-critical:
- `memory leak will occur if overlay removed` — just a kernel warning about device tree overlays, expected on Kria
- `IRQ index 8 not found` — known harmless message on KV260
- `debugfs: Directory already present` — another benign warning

---

Your terminal just looks "stuck" because the kernel log messages printed over your prompt. Just **press Enter** and you'll get your prompt back:

```bash
ubuntu@kria:~$
```

Then you're ready for the next step — pulling the Docker image:

```bash
docker pull xilinx/smartcam:2022.1
```

Note this will take a while depending on your network speed since it's a large image.

---

## Human (Jun 22, 2026, 4:51 PM):

ubuntu@kria:~$ sudo apt install xlnx-firmware-kv260-smartcam
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
xlnx-firmware-kv260-smartcam is already the newest version (0.12-0xlnx2).
0 upgraded, 0 newly installed, 0 to remove and 550 not upgraded.
ubuntu@kria:~$ sudo xmutil desktop_disable
ubuntu@kria:~$ sudo xmutil listapps
                     Accelerator          Accel_type                            Base           Base_type      #slots(PL+AIE)         Active_slot
                k26-starter-kits            XRT_FLAT                k26-starter-kits            XRT_FLAT               (0+0)                  0,
                  kv260-smartcam            XRT_FLAT                  kv260-smartcam            XRT_FLAT               (0+0)                  -1
ubuntu@kria:~$ sudo xmutil unloadapp
remove from slot 0 returns: 0 (Ok)
ubuntu@kria:~$ sudo xmutil loadapp kv260-smartcam
[  942.013161] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/firmware-name
[  942.023353] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /fpga-full/resets
kv260-smartcam: loaded to slot 0
ubuntu@kria:~$ [  942.240692] zocl-drm axi:zyxclmm_drm: IRQ index 8 not found
[  942.286114] debugfs: Directory '4-003c' with parent 'regmap' already present!

i think its stuck
is this okay

---

## Claude:

Docker isn't installed yet. Install it with:

```bash
sudo apt install docker.io -y
```

Then start and enable the Docker service:
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Then add your user to the docker group so you don't need `sudo` every time:
```bash
sudo usermod -aG docker $USER
```

Then apply the group change:
```bash
newgrp docker
```

Then verify it works:
```bash
docker --version
```

Once that's confirmed, pull the smartcam image:
```bash
docker pull xilinx/smartcam:2022.1
```

---

## Human (Jun 22, 2026, 4:51 PM):

ubuntu@kria:~$ docker pull xilinx/smartcam:2022.1
Command 'docker' not found, but can be installed with:
sudo snap install docker         # version 29.3.1, or
sudo apt  install docker.io      # version 29.1.3-0ubuntu3~22.04.2
sudo apt  install podman-docker  # version 3.4.4+ds1-1ubuntu1.22.04.3
See 'snap info docker' for additional versions.
ubuntu@kria:~$

---

## Claude:

Your webcam doesn't support 1920x1080. Based on the supported resolutions listed, the best option is **1280x720 at 7.5fps**. Run:

```bash
smartcam --usb 1 -W 1280 -H 720 -r 7 --target rtsp
```

---

Then on your **PC**, play the RTSP stream. First get the KV260's IP address — run this on the board:
```bash
ip addr show eth0
```

Then on your PC:
```bash
ffplay rtsp://<board-ip>:5000/test
```

---

If 1280x720 feels too slow at 7.5fps, you can also try **640x480 at 30fps** which gives much smoother video:
```bash
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
```

The tradeoff is lower resolution but much smoother motion — better for face detection demos since the AI tracks movement in real time.

---

## Human (Jun 22, 2026, 4:59 PM):

root@xlnx-docker:/# smartcam --usb 1 -W 1920 -H 1080 -r 30 --target rtsp
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 08:59:27.651: g_param_spec_float: assertion 'default_value >= minimum && default_value <= maximum' failed
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 08:59:27.651: validate_pspec_to_install: assertion 'G_IS_PARAM_SPEC (pspec)' failed
Error: USB camera doesn't support resolution 1920x1080
All supported resolution:
640x480
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
160x120
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
176x144
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
320x176
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
320x240
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
352x288
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
432x240
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
544x288
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
640x360
 30.000fps 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
752x416
 25.000fps 20.000fps 15.000fps 10.000fps 5.000fps 
800x448
 20.000fps 15.000fps 10.000fps 5.000fps 
800x600
 20.000fps 15.000fps 10.000fps 5.000fps 
864x480
 20.000fps 15.000fps 10.000fps 5.000fps 
960x544
 15.000fps 10.000fps 5.000fps 
960x720
 10.000fps 5.000fps 
1024x576
 10.000fps 5.000fps 
1184x656
 10.000fps 5.000fps 
1280x720
 7.500fps 5.000fps 
1280x960
 7.500fps 5.000fps 
root@xlnx-docker:/#

---

## Claude:

Your board's IP is **192.168.123.118**. 

First make sure the smartcam RTSP stream is running on the board (inside the Docker container):
```bash
smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
```

Then on your **PC**, open a terminal and run:
```bash
ffplay rtsp://192.168.123.118:5000/test
```

---

Make sure your PC is on the **same network subnet** (192.168.123.x) as the board, otherwise the stream won't reach you. You can verify on your PC with:
```bash
ip addr show
```

Look for an interface with an address like `192.168.123.xxx` — if your PC is on a different subnet, connect it to the same router/switch as the KV260.

---

## Human (Jun 22, 2026, 5:00 PM):

ubuntu@kria:~$ ip addr show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0a:35:0a:80:e1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.123.118/24 brd 192.168.123.255 scope global dynamic noprefixroute eth0
       valid_lft 6585sec preferred_lft 6585sec
    inet6 fe80::d895:c412:29cf:b8fe/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
ubuntu@kria:~$

---

## Claude:

The stream is running! I can see two things to fix:

**1. The port is 554, not 5000** — use this on your PC:
```bash
ffplay rtsp://192.168.123.118:554/test
```

**2. Your PC's network** — your PC is on `192.168.123.128` (via `enp0s31f6`), same subnet as the board (`192.168.123.118`), so the connection should work fine.

The `GLib-GObject-CRITICAL` warnings are harmless — the stream is ready as confirmed by the output.

---

Go ahead and run this on your PC now:
```bash
ffplay rtsp://192.168.123.118:554/test
```

You should see the webcam feed with face detection bounding boxes appear in a new window.

---

## Human (Jun 22, 2026, 5:01 PM):

ubuntu@kria:~$ docker run --env="DISPLAY" -h "xlnx-docker" --env="XDG_SESSION_TYPE" --net=host --privileged --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v /tmp:/tmp -v /dev:/dev -v /sys:/sys -v /etc/vart.conf:/etc/vart.conf -v /lib/firmware/xilinx:/lib/firmware/xilinx -v /run:/run -it xilinx/smartcam:2022.1 bash
==========================================
 _  __     _         ____   ___  __  __
| |/ /_ __(_) __ _  / ___| / _ \|  \/  |
| ' /|  __| |/ _  | \___ \| | | | |\/| |
| . \| |  | | (_| |  ___) | |_| | |  | |
|_|\_\_|  |_|\__ _| |____/ \___/|_|  |_|
==========================================
Build Date: 2022/09/26 15:21
root@xlnx-docker:/# smartcam --usb 1 -W 640 -H 480 -r 30 --target rtsp
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 09:00:38.832: g_param_spec_float: assertion 'default_value >= minimum && default_value <= maximum' failed
(gst-plugin-scanner:10): GLib-GObject-CRITICAL **: 09:00:38.832: validate_pspec_to_install: assertion 'G_IS_PARAM_SPEC (pspec)' failed
stream ready at:
 rtsp://172.17.0.1:554/test
rtsp://192.168.123.118:554/test

---

