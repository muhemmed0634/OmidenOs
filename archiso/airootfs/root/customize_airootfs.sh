#!/usr/bin/env bash
# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# Runs inside the airootfs after package installation. Files owned by
# packages cannot be placed in the airootfs overlay (mkarchiso copies
# the overlay before pacman runs and pacman rejects the file conflict),
# so the identity files are written here instead.
# mkarchiso 92 still executes this script, but marks it deprecated;
# revisit this mechanism when archiso removes support for it.

set -euo pipefail

cat >/usr/lib/os-release <<'EOF'
NAME="OmidenOS"
PRETTY_NAME="OmidenOS"
ID=omidenos
VERSION_ID="2026.11"
VERSION="2026.11 (Live)"
BUILD_ID="2026.11.17"
ANSI_COLOR="1;35"
HOME_URL="https://github.com/muhemmed0634/OmidenOs"
DOCUMENTATION_URL="https://github.com/muhemmed0634/OmidenOs/tree/main/docs"
SUPPORT_URL="https://github.com/muhemmed0634/OmidenOs/issues"
BUG_REPORT_URL="https://github.com/muhemmed0634/OmidenOs/issues"
LOGO=omidenos-logo
EOF

# The live medium keeps upstream's "uninitialized" machine-id (mkarchiso
# rewrites it in _cleanup_pacstrap_dir after this script runs), so the
# first-boot unit is masked via the airootfs overlay at
# etc/systemd/system/systemd-firstboot.service. Without that mask the
# unit opens an interactive setup prompt on tty1, covering the live
# session with upstream-branded text.

# Neutralize the upstream package-manager account description that is
# visible in /etc/passwd on the live system.
sed -E -i 's/^(alpm:x:970:970:)[^:]*:/\1Package Management:/' /etc/passwd
