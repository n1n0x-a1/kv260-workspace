# KV260 Platform Migration Research — Yocto/PetaLinux → Official Ubuntu

> **TL;DR: Stop building the base OS ourselves. AMD/Canonical ship a certified, pre-built Ubuntu 22.04/24.04 LTS image for the KV260 that already solves most of the problems documented in `camera_setup_guide.md` (AP1302 driver disabled, manual per-boot kernel module loading, cgroup v1 hacks for KubeEdge). Recommendation: keep Phase 1 (Vivado/Vitis hardware + DPU overlay build) as-is, replace Phase 2 (custom Yocto OS build) with the official Ubuntu image, and switch orchestration from KubeEdge to k3s to drop the cgroup v1 `system.dtb` bootarg patch entirely.**

This is a research doc, not yet an implemented migration. It exists because today's session confirmed the current Yocto base is fragile (manual `menuconfig` + module rebuilds for AP1302, a confirmed-unfixable USB webcam kernel bug, missing VCU/Allegro driver, and a custom `system.dtb` bootarg patch required just to make KubeEdge's `edgecore` tolerate the image's cgroup setup). None of that is sustainable as a long-term base for the K8s/K3s + Ubuntu 24.04 ecosystem described in `README.md`.

---

## 1. Why we're looking for an alternative

From `camera_setup_guide.md` and this session's KV260 terminal work:

- `CONFIG_VIDEO_AP1302` was disabled in our custom kernel config and had to be manually flipped to `=m`, rebuilt as a `.ko`, and `insmod`'d **every boot** (nothing persists except the firmware blob).
- The Logitech C270 USB webcam path is a **confirmed dead end** on our current kernel — `uvcvideo` decodes frames internally but `VIDIOC_DQBUF` hangs forever; ruled out as a config issue, looks like a kernel/xHCI bug specific to this build.
- The VCU (hardware H.264 encoder) doesn't work at all — `/dev/allegroIP` doesn't exist; the Allegro VCU driver isn't in our kernel build.
- `README.md` Phase 3 requires hand-patching `system.dtb` bootargs (`systemd.unified_cgroup_hierarchy=0 ...`) just so `edgecore` (KubeEdge) tolerates cgroup v1/v2 hybrid mode — a workaround for a self-built image, not a documented supported configuration.
- Container tooling on the board (`crictl`, `kubectl`) isn't even installed/in `PATH` on the worker node, meaning day-to-day cluster debugging requires falling back to raw `ctr`.

All of this stems from the same root cause: we're hand-rolling the OS image (Yocto/PetaLinux) instead of using a maintained, certified one.

---

## 2. What AMD/Canonical actually ship

- **Certified Ubuntu images exist for KV260**, officially published by Canonical in partnership with AMD — both **Ubuntu 22.04 LTS** and **Ubuntu 24.04 LTS** builds are available for direct download and flashing (via Raspberry Pi Imager or balenaEtcher), no Yocto/BitBake step required. ([AMD Wiki: Certified Ubuntu 22.04 LTS for Xilinx Devices](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/2363129857/Getting+Started+with+Certified+Ubuntu+22.04+LTS+for+Xilinx+Devices.), [Kria KV260 Linux Boot — Ubuntu 24.04 docs](https://xilinx.github.io/kria-apps-docs/kv260/2022.1/linux_boot/ubuntu_24_04/build/html/docs/sdcard.html))
- **Prerequisite**: the KV260's boot firmware must be at **2022.1 or later** — the legacy 2021.1 boot firmware will not boot the Ubuntu 22.04+ image. This is a one-time firmware update, not a kernel rebuild. ([AMD Wiki: Kria K26 SOM](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1641152513/Kria+K26+SOM))
- **Xilinx App Store** ships pre-built accelerated applications as **snaps** — including the same `smartcam` reference design we've been hand-building (AP1302 ISP capture + DPU inference + output pipeline), installable in "under an hour, no FPGA experience needed." The snap bundles the PL overlay (bitstream) alongside the application. ([Kria KV260 Apps index](https://xilinx.github.io/kria-apps-docs/kv260-docs.html), [Bringing AI to the Edge — Hackster.io](https://www.hackster.io/news/bringing-ai-to-the-edge-xilinx-s-new-kria-som-lineup-with-embedded-app-store-c885dec0a2ee))
- Because `smartcam` is the **primary, officially-targeted application** for this exact AP1302+DPU hardware combination on Ubuntu 22.04, the AP1302 driver path is something AMD maintains and tests — not something we should expect to hit disabled in `menuconfig` the way our Yocto build did.
- **VCU is *not* enabled by default** even on the official Ubuntu image ("Xilinx Kria does not have the VCU in their default design in Ubuntu 22.04, and it does not have GStreamer installed either"), but AMD provides documented apt package repositories to enable VCU + GStreamer + OMX + V4L2 on top of the official image, rather than requiring us to port/build the Allegro kernel driver ourselves. ([RidgeRun: Enable the VCU on Ubuntu 22.04](https://developer.ridgerun.com/wiki/index.php/Xilinx_ZYNQ_UltraScale+_MPSoC/Xilinx_Kria/Enable_the_VCU_on_Ubuntu_2022.4))
- There's also an official **`kv260_isp_MipiRx_vcu_DP`** accelerated-application platform target (same shape as our custom `kv260_ispMipiRx_vcu_DP` Vitis platform) — meaning a VCU-enabled ISP+DP pipeline is a known, documented configuration upstream, not something unique to our build.

---

## 3. Orchestration: K3s instead of KubeEdge removes the cgroup hack entirely

- Modern K3s (v1.25+) has **native cgroup v2 support** — Kubernetes itself has supported cgroup v2 since 1.25, and K3s's bundled containerd handles it with no special configuration. Manual cgroup tuning was only needed for *pre-1.25* K3s. ([K3s docs: Requirements](https://docs.k3s.io/installation/requirements), [About cgroup v2 — Kubernetes docs](https://kubernetes.io/docs/concepts/architecture/cgroups/))
- Ubuntu 22.04/24.04 ship with cgroup v2 by default and K3s installs on them with **zero bootarg patching** — i.e. our `system.dtb` "force cgroup v1 hybrid mode" hack (`README.md` Phase 3, step 3) was a workaround specifically required by **KubeEdge's `edgecore`**, not an inherent KV260/Yocto limitation.
- This means switching the edge node from `edgecore` (KubeEdge) to a plain **K3s agent** joining the existing K3s/K8s master would let us drop the custom `system.dtb` entirely and boot the board with AMD's unmodified boot assets.
- `README.md`'s own comparison matrix already documents K3s as the simpler, lower-overhead option for LAN-local clusters (vs. KubeEdge's edge-autonomy benefits, which we don't need on a board with stable LAN connectivity to `master.ninox.com`) — this research just adds the concrete reason to prefer it: it's compatible with the *unmodified* official Ubuntu image.

---

## 4. Recommended path forward

| Stage | Today (Yocto/PetaLinux) | Proposed (Official Ubuntu) |
|---|---|---|
| Base OS | Custom `bitbake petalinux-image-minimal` build, hand-maintained `.config`, brittle/non-reproducible | Canonical-certified Ubuntu 22.04/24.04 LTS image, flashed directly |
| Boot firmware | N/A (image-level concern only) | One-time bump to 2022.1+ boot firmware (prerequisite) |
| AP1302/camera | `CONFIG_VIDEO_AP1302=m` manually enabled, module rebuilt + `insmod`'d every boot, firmware blob hand-copied | Expected to work via the official `smartcam` snap/app path — **needs validation on real hardware**, see open items below |
| VCU/H.264 | Missing entirely (`/dev/allegroIP` absent) | Documented apt-based enablement path exists (RidgeRun guide) — not zero-effort, but a supported procedure instead of a from-scratch driver port |
| USB webcam | Confirmed kernel-level dead end | Different (AMD-maintained) kernel — bug may or may not still reproduce; **needs retesting**, not assumed fixed |
| Orchestration | KubeEdge `edgecore`, requires custom `system.dtb` cgroup v1 bootarg patch | K3s agent, native cgroup v2 support on stock Ubuntu, no DTB patch needed |
| Hardware/DPU build (Phase 1) | Vivado/Vitis platform + DPU overlay build in Ubuntu 20.04 container | **Unchanged** — bitstream/`.xclbin`/`arch.json` synthesis is independent of which OS runs on the board; same artifacts, just deployed onto the official image instead of baked into a custom Yocto rootfs |

**Net effect**: Phase 1 of `README.md` (hardware/DPU compilation) stays exactly as documented. Phase 2 (Yocto build) is replaced by "flash the official image + bump boot firmware." Phase 3's `system.dtb` patch step disappears. Phase 5's KubeEdge-specific setup (`keadm`, `edgecore`, MQTT mode patch) is replaced by a standard `k3s agent` join command.

---

## 5. Open items to validate before committing to the migration

These are explicitly **not yet confirmed** — research only, nothing tested on hardware:

1. **AP1302 on official Ubuntu**: confirm the `smartcam` snap actually probes the AP1302 successfully out of the box on our specific board/carrier, and that our *custom* DPU model (face-mask detection, ResNet50, the `smart_model_select` swap workflow in `README.md` §5.6) can be redeployed against it without needing our own kernel module build.
2. **USB webcam retest**: re-run the exact `v4l2-ctl`/`gst-launch` repro from `camera_setup_guide.md` §3 against the official Ubuntu kernel. The bug was characterized as kernel/xHCI-specific — a different (AMD-maintained) kernel build may or may not exhibit it. Don't assume fixed; verify.
3. **VCU enablement cost**: the RidgeRun procedure for enabling VCU on Ubuntu requires adding AMD's package repo and installing custom GStreamer/OMX/V4L2 packages — scope the actual steps/risk before relying on hardware H.264 again.
4. **Custom Vitis platform compatibility**: our DPU overlay is built from a custom Vitis platform (`kv260_ispMipiRx_vcu_DP`, not the stock out-of-box one) with custom VVAS overlay patches (`change/vvas-overlay/`). Confirm the official Ubuntu image's snap/overlay-loading mechanism (`xmutil`-equivalent or `fpgautil`) can load a **custom-built** bitstream the same way it loads AMD's own app-store bitstreams, rather than only accepting App Store-signed packages.
5. **K3s vs KubeEdge tradeoff**: `README.md` §"Alternative Orchestration" already notes KubeEdge's edge-autonomy benefits (offline persistence, NAT traversal). Confirm we don't actually need those given the board has stable LAN connectivity to `master.ninox.com` — if we do, KubeEdge's `edgecore` may still need to run on Ubuntu, which should be checked against cgroup v2 compatibility directly (it may also have been fixed upstream since our Yocto-era testing).

---

## Sources

- [Getting Started with Certified Ubuntu 22.04 LTS for Xilinx Devices — AMD Wiki](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/2363129857/Getting+Started+with+Certified+Ubuntu+22.04+LTS+for+Xilinx+Devices.)
- [Kria KV260: Linux Boot — Ubuntu 24.04 docs](https://xilinx.github.io/kria-apps-docs/kv260/2022.1/linux_boot/ubuntu_24_04/build/html/docs/sdcard.html)
- [Kria K26 SOM — AMD Wiki](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1641152513/Kria+K26+SOM)
- [Kria KV260 Vision AI Starter Kit Applications index](https://xilinx.github.io/kria-apps-docs/kv260-docs.html)
- [Bringing AI to the Edge: Xilinx's New Kria SOM Lineup with Embedded App Store — Hackster.io](https://www.hackster.io/news/bringing-ai-to-the-edge-xilinx-s-new-kria-som-lineup-with-embedded-app-store-c885dec0a2ee)
- [Easy Machine Learning on Ubuntu with the AMD Kria KV260 — Hackster.io](https://www.hackster.io/dsp2/easy-machine-learning-on-ubuntu-with-the-amd-kria-kv260-c77ed1)
- [Enable the VCU on Ubuntu 22.04 — RidgeRun Developer Wiki](https://developer.ridgerun.com/wiki/index.php/Xilinx_ZYNQ_UltraScale+_MPSoC/Xilinx_Kria/Enable_the_VCU_on_Ubuntu_2022.4)
- [K3s Requirements docs](https://docs.k3s.io/installation/requirements)
- [About cgroup v2 — Kubernetes docs](https://kubernetes.io/docs/concepts/architecture/cgroups/)
