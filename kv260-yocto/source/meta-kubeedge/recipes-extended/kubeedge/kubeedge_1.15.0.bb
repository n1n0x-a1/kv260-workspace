SUMMARY = "KubeEdge EdgeCore and Keadm binaries"
DESCRIPTION = "KubeEdge is an open source system for extending native containerized application orchestration capabilities to hosts at the Edge."
HOMEPAGE = "https://kubeedge.io"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
    https://github.com/kubeedge/kubeedge/releases/download/v1.15.0/kubeedge-v1.15.0-linux-arm64.tar.gz;name=kubeedge \
    https://github.com/kubeedge/kubeedge/releases/download/v1.15.0/keadm-v1.15.0-linux-arm64.tar.gz;name=keadm \
"

SRC_URI[kubeedge.sha256sum] = "0089d8d7f689b16d7d952f486881de4f03e0876f1b851c3bae2b231f434433f2"
SRC_URI[keadm.sha256sum] = "5ae9e2fbc3e31fda139d6765b83c4d2988ae2530649c060d1c8ad6dc0b1d0e92"

S = "${WORKDIR}"

# We are packaging pre-compiled binaries, so prevent any build tasks
do_configure[noexec] = "1"
do_compile[noexec] = "1"

# We must skip QA checks for prebuilt binaries (like host-user-contaminated, ldflags, textrel)
INSANE_SKIP:${PN} += "already-stripped ldflags buildpaths"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/kubeedge-v1.15.0-linux-arm64/edge/edgecore ${D}${bindir}/edgecore
    install -m 0755 ${S}/keadm-v1.15.0-linux-arm64/keadm/keadm ${D}${bindir}/keadm

    install -d ${D}${sysconfdir}/kubeedge/config
}

FILES:${PN} = " \
    ${bindir}/edgecore \
    ${bindir}/keadm \
    ${sysconfdir}/kubeedge \
"
