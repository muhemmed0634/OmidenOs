#!/usr/bin/env bash
# OmidenOS - ArchISO Profile Definition
# GitHub: https://github.com/muhemmed0634/OmidenOS
# shellcheck disable=SC2034

iso_name="omiden"
iso_label="OMIDEN_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="OmidenOS <https://github.com/muhemmed0634/OmidenOS>"
iso_application="OmidenOS Live/Installation Medium"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
bootmodes=('uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '3' '-b' '1M' '-processors' '8')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/install-omiden"]="0:0:755"
  ["/usr/local/bin/omiden-welcome"]="0:0:755"
  ["/usr/local/bin/setup-blackarch"]="0:0:755"
  ["/usr/local/bin/install-tools"]="0:0:755"
  ["/usr/local/bin/install-waypaper"]="0:0:755"
)
