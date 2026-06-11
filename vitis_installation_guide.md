# Installing Xilinx Vitis / Vivado 2022.1 on Ubuntu 24.04

Since Xilinx Vitis 2022.1 is built for Ubuntu 20.04 and does not support Ubuntu 24.04 natively (due to library version mismatches with `glibc`, `gcc`, and others), the recommended approach is to install and run Vitis inside a **persistent Ubuntu 20.04 Docker container**.

The installation files will be stored on your host machine under `/home/syvesdh/Xilinx` (so they are not lost if the container is removed) but the software will be executed inside the container environment.

---

## Step 1: Download the Vitis 2022.1 Installer
1. Go to the AMD/Xilinx Downloads Page: [AMD Vitis 2022.1 Archive](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis/archive.html).
2. Download the **Xilinx Unified Installer 2022.1: Linux Self-Extracting Web Installer** (`Xilinx_Unified_2022.1_0420_0327_Lin64.bin`).
   * *Note: Keep the downloaded file in your `~/Downloads` directory.*

---

## Step 2: Prepare Host Directories
Create the destination folder on your host machine where the Vitis tools will be permanently installed:
```bash
mkdir -p /home/syvesdh/Xilinx
```

---

## Step 3: Run the Ubuntu 20.04 Installer Container
Launch a temporary Docker container to run the installer, mapping your downloads directory, Xilinx install directory, and X11 display settings (so you can use the graphical installer):

```bash
# Allow local docker containers to connect to your X11 graphical display
xhost +local:docker

# Start the installer container
docker run -it \
  --name vitis-installer-run \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/syvesdh/Xilinx:/tools/Xilinx \
  -v /home/syvesdh/Downloads:/home/syvesdh/Downloads \
  ubuntu:20.04 bash
```

---

## Step 4: Install Dependencies (Inside Container)
Inside the container terminal, run the following commands to install the required graphical and build dependencies for the installer and Vivado:

```bash
apt-get update && apt-get install -y \
  build-essential \
  libncurses5 \
  libtinfo5 \
  libncurses5-dev \
  libncursesw5-dev \
  libtinfo-dev \
  libxml2-dev \
  unzip \
  gzip \
  tar \
  python3 \
  locales \
  libglib2.0-0 \
  libxext6 \
  libxrender1 \
  libxtst6 \
  libxi6 \
  libsm6 \
  libxrandr2 \
  libfontconfig1 \
  libxft2 \
  libx11-xcb1 \
  libxcb-icccm4 \
  libxcb-image0 \
  libxcb-keysyms1 \
  libxcb-randr0 \
  libxcb-render-util0 \
  libxcb-xinerama0 \
  libxkbcommon-x11-0 \
  libdbus-1-3
```

---

## Step 5: Run the Graphical Installer (Inside Container)
1. Navigate to the downloads folder inside the container:
   ```bash
   cd /home/syvesdh/Downloads
   ```
2. Make the installer executable:
   ```bash
   chmod +x Xilinx_Unified_2022.1_0420_0327_Lin64.bin
   ```
3. Run the installer:
   ```bash
   ./Xilinx_Unified_2022.1_0420_0327_Lin64.bin
   ```
4. **Follow the GUI Steps:**
   * Enter your AMD/Xilinx login credentials.
   * Choose **Vitis** (this installs both Vitis and Vivado).
   * **Destination Directory:** Keep the default `/tools/Xilinx` (since `/tools/Xilinx` inside the container maps directly to `/home/syvesdh/Xilinx` on your host).
   * Agree to the license agreements and begin the download and installation.

---

## Step 6: Post-Installation & Running Vitis/Vivado
Once the installation completes, you can exit and remove the installer container (`docker rm vitis-installer-run`).

To run Vitis or Vivado in the future, launch your development container:
```bash
docker run -it \
  --name vitis-builder \
  --net=host \
  -e TERM=xterm-256color \
  -v /home/syvesdh/NinoxWorkspace/kv260-workspace:/home/syvesdh/NinoxWorkspace/kv260-workspace \
  -v /home/syvesdh/Xilinx:/tools/Xilinx \
  -v /opt/Xilinx:/opt/Xilinx \
  ubuntu:20.04 bash
```
Inside the container, install the required packages, generate the locale, source the environment, and build the platform:
```bash
# Enable colored terminal prompt
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc
source ~/.bashrc

# Install build tools, required Vivado/XSCT libraries, and locales
apt-get update && apt-get install -y build-essential git make locales libtinfo5 libncurses5 x11-utils xvfb dbus-x11 libgtk-3-0 unzip

# Generate locale to prevent Vivado crash
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source /tools/Xilinx/Vitis/2022.1/settings64.sh
cd /home/syvesdh/NinoxWorkspace/kv260-workspace/smartapp-modified/kv260-smartapp-platform/kria-vitis-platforms/kv260
make platform PFM=kv260_ispMipiRx_vcu_DP
```
