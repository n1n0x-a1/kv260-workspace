DESCRIPTION = "KV260 VVAS smart_model_select related packages"

inherit packagegroup

KV260_VVAS_SMS_PACKAGES = " \
   ap1302-ar1335-single-firmware \
   kv260-vvas-sms \
   kv260-vvas-sms-models \
   kv260-vvas-sms-app \
   git \
   dnf \
   libdrm libdrm-tests libdrm-kms \
   xrt xrt-dev \
   zocl \
   make \
   binutils \
   glibc \
   libgcc \
   openssh-sftp openssh-sftp-server openssh-scp \
   opencl-headers \
   packagegroup-petalinux-vitisai \
   packagegroup-petalinux-vitisai-dev \
   packagegroup-petalinux-gstreamer \
   packagegroup-petalinux-opencv \
   packagegroup-petalinux-v4lutils \
   packagegroup-petalinux-x11 \
   packagegroup-core-buildessential \
   packagegroup-core-sdk \
   gstreamer-vcu-examples \
   htop \
   jansson \
   target-factory \
   unilog vart vitis-ai-library xir \
   vvas-accel-libs vvas-gst vvas-utils \
   "

RDEPENDS:${PN} = "${KV260_VVAS_SMS_PACKAGES}"

 
#COMPATIBLE_MACHINE = "^$"
#COMPATIBLE_MACHINE_k26-kv = "${MACHINE}"
#PACKAGE_ARCH = "${BOARDVARIANT_ARCH}"
