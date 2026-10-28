#!/usr/bin/env bash
# OmidenOs - ArchISO Profile Definition
# GitHub: https://github.com/muhemmed0634/OmidenOs

iso_name="omidenos"
iso_label="OMIDEN_$(date +%Y%m)"
iso_publisher="OmidenOs <https://github.com/muhemmed0634/OmidenOs>"
iso_application="OmidenOs Live/Installation Medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/install-omiden"]="0:0:755"
  ["/usr/local/bin/omiden-welcome"]="0:0:755"
  ["/usr/local/bin/setup-blackarch"]="0:0:755"
)
