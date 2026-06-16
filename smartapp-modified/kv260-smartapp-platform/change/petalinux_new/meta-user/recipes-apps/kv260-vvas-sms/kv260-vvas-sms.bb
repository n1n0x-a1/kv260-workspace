#
# This file is the kv260-vvas-sms recipe.
#

SUMMARY = "Simple kv260-vvas-sms to use fpgamanager class"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit fpgamanager_custom

SRC_URI = "file://kv260-vvas-sms.bit \
           file://kv260-vvas-sms.dtsi \
           file://kv260-vvas-sms.xclbin \
           file://shell.json \
           "

S = "${WORKDIR}"
