#!/usr/bin/env bash
# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# OmidenOS live-medium profile definition, derived from the mkarchiso
# releng profile of archiso 92-1. UEFI-only: BIOS bootmodes, syslinux
# and grub directories are intentionally absent (section 4 of the
# product spec, ADR-0007).

iso_name="omidenos"
iso_label="OMIDENOS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="OmidenOS Project <https://github.com/muhemmed0634/OmidenOs>"
iso_application="OmidenOS Live/Installer"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="omidenos"
bootmodes=('uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86,arm64' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d/live-omiden"]="0:0:440"
  ["/etc/issue"]="0:0:644"
  ["/usr/local/bin/boot-report"]="0:0:755"
  ["/usr/local/bin/omidenos-session"]="0:0:755"
  ["/root"]="0:0:750"
)
