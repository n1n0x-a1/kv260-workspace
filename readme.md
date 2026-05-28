# KV260 Yocto/PetaLinux Build Environment

This repository contains the configuration and documentation for building a custom, minimal embedded Linux distribution for a Xilinx Kria KV260 Vision AI Starter Kit using the **Yocto Project (Poky)** and Xilinx’s layers (matching the PetaLinux 2024.2 ecosystem).

It also includes notes on a pre-configured OS environment that runs Kubernetes (Talos k8s) or Proxmox VE at the edge.

---

## 🛠️ Tools Usage
* **git**: For fetching meta-layers and repository management.
* **bitbake**: The core build engine for the Yocto Project used to compile the Linux image.
* **balenaEtcher**: (Recommended) For flashing the compiled `.wic.gz` image directly to your SD Card.

## 📋 Device & Version Check
* **Target Board:** Kria KV260 Vision AI Starter Kit
* **Host OS:** Ubuntu 24.04 LTS
* **Xilinx Layers:** `rel-v2024.2`
* **Poky (Yocto Version):** `scarthgap` (Yocto 5.0)
* **ROS 2:** `jazzy`

---

## 🛠️ Ubuntu 24.04 AppArmor Fix (Required)

Ubuntu 24.04 introduces strict AppArmor profiles that block unprivileged user namespaces by default. BitBake relies on these namespaces for network isolation during build tasks. Before running any builds, you **must** temporarily disable this restriction on your host machine:

```bash
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```
*(Note: This setting resets upon reboot. You only need to run it once per boot session before building.)*

---

## 📁 Folder Structure Overview

```text
{path_to_workspace}/kv260-yocto/
├── poky/                  # The core Yocto Project build system repository
│   └── build/             # Generated after initialization (contains outputs & local configs)
│       ├── conf/          # Contains local.conf and bblayers.conf
│       └── tmp/deploy/    # Final output destination for compiled images
└── source/                # Directory containing all supplementary meta-layers
    ├── meta-openembedded  # Additional OpenEmbedded recipes
    ├── meta-xilinx        # Xilinx-specific hardware layers
    ├── meta-ros           # ROS 2 robotics recipes
    └── ...
```

---

## 🚀 Setup & Build Guide

### Step 1: Set Up the Directory Structure

You need to organize your workspace precisely so that the configuration files point to the correct relative paths.

1. Create a base directory for your project and a `source` directory inside it:
```bash
mkdir -p {path_to_workspace}/kv260-yocto/source
cd {path_to_workspace}/kv260-yocto/source
```

### Step 2: Clone the Required Layers

The repository relies on specific versions of layers matched to the `rel-v2024.2` release (Yocto version **Scarthgap**). Run the following commands to clone all necessary layers into your `{path_to_workspace}/kv260-yocto/source` folder:

```bash
# Clone Poky (the Yocto reference distribution) one level up
cd {path_to_workspace}/kv260-yocto
git clone -b rel-v2024.2 https://github.com/Xilinx/poky.git

# Clone all required meta-layers into the source directory
cd {path_to_workspace}/kv260-yocto/source
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-openembedded.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-openamp.git
git clone -b scarthgap https://github.com/kraj/meta-clang.git
git clone -b scarthgap https://github.com/OSSystems/meta-browser.git
git clone -b scarthgap/rust https://git.yoctoproject.org/meta-lts-mixins.git
git clone -b scarthgap https://git.yoctoproject.org/meta-arm.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-petalinux.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-xilinx.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-xilinx-tools.git
git clone -b scarthgap https://github.com/meta-qt5/meta-qt5.git
git clone -b 6.7 git://code.qt.io/yocto/meta-qt6.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-virtualization.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-jupyter.git
git clone -b rel-v2024.2 https://github.com/Xilinx/meta-ros.git
```

#### Complete Layer Reference Table

*(Note: The canonical source for verifying layer dependencies and branches for Yocto 5.0 is the [OpenEmbedded Scarthgap Layer Index](https://layers.openembedded.org/layerindex/branch/scarthgap/layers/).)*

| Layer Name | Repository Website | Target Branch |
| :--- | :--- | :--- |
| **poky** | https://github.com/Xilinx/poky | `rel-v2024.2` |
| **meta-openembedded** | https://github.com/Xilinx/meta-openembedded | `rel-v2024.2` |
| **meta-openamp** | https://github.com/Xilinx/meta-openamp | `rel-v2024.2` |
| **meta-clang** | https://github.com/kraj/meta-clang | `scarthgap` |
| **meta-browser** | https://github.com/OSSystems/meta-browser | `scarthgap` |
| **meta-lts-mixins** | https://git.yoctoproject.org/meta-lts-mixins | `scarthgap/rust` |
| **meta-arm** | https://git.yoctoproject.org/meta-arm | `scarthgap` |
| **meta-petalinux** | https://github.com/Xilinx/meta-petalinux | `rel-v2024.2` |
| **meta-xilinx** | https://github.com/Xilinx/meta-xilinx | `rel-v2024.2` |
| **meta-xilinx-tools** | https://github.com/Xilinx/meta-xilinx-tools | `rel-v2024.2` |
| **meta-qt5** | https://github.com/meta-qt5/meta-qt5 | `scarthgap` |
| **meta-qt6** | git://code.qt.io/yocto/meta-qt6.git | `6.7` |
| **meta-virtualization** | https://github.com/Xilinx/meta-virtualization | `rel-v2024.2` |
| **meta-jupyter** | https://github.com/Xilinx/meta-jupyter | `rel-v2024.2` |
| **meta-ros** | https://github.com/Xilinx/meta-ros | `rel-v2024.2` |

---

## ⚙️ Build Configuration

### Step 3: Initialize the Build Environment

Run the initialization script from the `poky` directory. This script creates a `build` directory and populates it with template configuration files, while setting up your terminal environmental variables.

```bash
cd {path_to_workspace}/kv260-yocto/poky
source oe-init-build-env
```

*(Note: This automatically shifts your terminal working directory into `{path_to_workspace}/kv260-yocto/poky/build`)*

### Step 4: Configure `bblayers.conf`

Open your layer configuration file:

```bash
nano conf/bblayers.conf
```

Replace its contents with the block provided in the repository to explicitly link all the cloned meta-layers. Make sure the `SOURCEPATH` matches your local profile (e.g., using `${TOPDIR}/../../source` is a safe relative way to do this):

```bitbake
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "${TOPDIR}"
BBFILES ?= ""
SOURCEPATH = "${TOPDIR}/../../source"

BBLAYERS ?= " \
  ${SOURCEPATH}/../poky/meta \
  ${SOURCEPATH}/../poky/meta-poky \
  ${SOURCEPATH}/meta-openembedded/meta-perl \
  ${SOURCEPATH}/meta-openembedded/meta-python \
  ${SOURCEPATH}/meta-openembedded/meta-filesystems \
  ${SOURCEPATH}/meta-openembedded/meta-gnome \
  ${SOURCEPATH}/meta-openembedded/meta-multimedia \
  ${SOURCEPATH}/meta-openembedded/meta-networking \
  ${SOURCEPATH}/meta-openembedded/meta-webserver \
  ${SOURCEPATH}/meta-openembedded/meta-xfce \
  ${SOURCEPATH}/meta-openembedded/meta-initramfs \
  ${SOURCEPATH}/meta-openembedded/meta-oe \
  ${SOURCEPATH}/meta-clang \
  ${SOURCEPATH}/meta-browser/meta-chromium \
  ${SOURCEPATH}/meta-xilinx/meta-microblaze \
  ${SOURCEPATH}/meta-xilinx/meta-xilinx-core \
  ${SOURCEPATH}/meta-xilinx/meta-xilinx-bsp \
  ${SOURCEPATH}/meta-xilinx/meta-xilinx-contrib \
  ${SOURCEPATH}/meta-xilinx/meta-xilinx-standalone \
  ${SOURCEPATH}/meta-xilinx-tools \
  ${SOURCEPATH}/meta-petalinux \
  ${SOURCEPATH}/meta-qt5 \
  ${SOURCEPATH}/meta-qt6 \
  ${SOURCEPATH}/meta-lts-mixins \
  ${SOURCEPATH}/meta-arm/meta-arm \
  ${SOURCEPATH}/meta-arm/meta-arm-toolchain \
  ${SOURCEPATH}/meta-openamp \
  ${SOURCEPATH}/meta-ros/meta-ros2 \
  ${SOURCEPATH}/meta-ros/meta-ros2-jazzy \
  ${SOURCEPATH}/meta-ros/meta-ros-common \
  ${SOURCEPATH}/meta-virtualization \
  ${SOURCEPATH}/meta-jupyter \
  "
```

### Step 5: Configure `local.conf`

Open your local configuration variables file:

```bash
nano conf/local.conf
```

Append the following targets to the bottom of the file:

```bitbake
DISTRO ?= "petalinux"
MACHINE ??= "zynqmp-generic"
IMAGE_FSTYPES = "wic.gz"
INHERIT += "rm_work"

# Accept Xilinx restricted licenses
LICENSE_FLAGS_ACCEPTED += "xilinx"

# Define the PetaLinux version for the meta-petalinux layer
PETALINUX_VERSION = "2024.2"

# Enable virtualization features for Docker/k8s support
DISTRO_FEATURES:append = " virtualization"
```

> 💡 **Tip:** `INHERIT += "rm_work"` clears out temporary build directories after a package is successfully built. This is highly recommended to save tens of gigabytes of storage space.

---

## 🔨 Execution & Deployment

### Step 6: Compile the Image

Kick off the BitBake compilation process. This step can take anywhere from 1 to several hours depending on your host computer's processor and internet speed.

```bash
bitbake petalinux-image-minimal
```

### Step 7: Flash the SD Card

We have two choices to finish our work. **Option 2 (using BalenaEtcher)** is highly recommended as it is much faster and cleaner.

**Option 1: Manual Partitioning (GParted)**
1. Use GParted to partition your SD card into two sections: `|FAT32|------Ext4-------|`
2. **FAT32 (Boot):** Copy `boot.src` and `system.dtb` (from this repository), along with the `Image` and `ramdisk.cpio.gz.u-boot` files:
   ```bash
   cp {path_to_workspace}/kv260-yocto/poky/build/tmp/deploy/images/zynqmp-generic/Image /media/$USER/BOOT/
   cp {path_to_workspace}/kv260-yocto/poky/build/tmp/deploy/images/zynqmp-generic/petalinux-image-minimal-zynqmp-generic.cpio.gz.u-boot /media/$USER/BOOT/ramdisk.cpio.gz.u-boot
   ```
3. **Ext4 (RootFS):** Extract the `tar.gz` root filesystem to the Ext4 partition:
   ```bash
   sudo tar xvf {path_to_workspace}/kv260-yocto/poky/build/tmp/deploy/images/zynqmp-generic/petalinux-image-minimal-zynqmp-generic.tar.gz -C /media/$USER/ROOTFS/
   ```

**Option 2: BalenaEtcher (Recommended)**
1. Locate your built flashable image:
`{path_to_workspace}/kv260-yocto/poky/build/tmp/deploy/images/zynqmp-generic/petalinux-image-minimal-zynqmp-generic.wic.gz`
2. Insert your micro-SD card into your host machine and use **balenaEtcher** to flash that `.wic.gz` file directly onto the card.
3. Once flashed, open the small **BOOT** partition of the SD card on your computer and copy/replace the `boot.scr` and `system.dtb` files located in the root of this clone repository onto that partition.

---

## 💻 Post-Boot Configuration & Login

Safely eject the SD card, insert it into your KV260 board, and power it up. You can interface with it using a serial console connection (like PuTTY or Minicom) or via an attached display/keyboard.

* **Username:** `root`
* **Password:** `nino123x`

### Post-Installation Adjustments

The documentation notes specific files to edit directly on the live target file system if you need to alter network states:

* **Ethernet/Static IP configurations:** Edit `/etc/network/interfaces`
* **Wi-Fi configurations:** Edit credentials inside `/etc/wpa_supplicant/wpa_supplicant.conf`

Additionally, if your built cluster includes Edge-Cloud controls, you can use the built-in hooks to manage your infrastructure:

* Access the Proxmox UI via: `https://<your_board_ip>:8006`
* To reset or resolve unresponsive Talos Kubernetes nodes, navigate to `~/Edge-Cloud/01-.../` on your system, adjust instances in `var.ft`, run `terraform apply`, and run `./bootstrap.sh`.
