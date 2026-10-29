#!/bin/bash
# ============================================================
# OmidenOs - Flash ISO to USB
# GitHub: https://github.com/muhemmed0634/OmidenOs
# Usage: sudo ./scripts/flash-usb.sh
# ============================================================

set -e

R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m'
C='\033[0;36m' W='\033[1;37m' N='\033[0m' BOLD='\033[1m'

info()  { echo -e "  ${G}[✔]${N} $*"; }
warn()  { echo -e "  ${Y}[!]${N} $*"; }
err()   { echo -e "  ${R}[✘]${N} $*"; }

echo -e "${C}${BOLD}"
echo "╔═══════════════════════════════════════╗"
echo "║     OmidenOs USB Flasher              ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${N}"

# ─── Check root ───────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    err "Must be run as root: sudo ./scripts/flash-usb.sh"
    exit 1
fi

# ─── Find ISO ─────────────────────────────────────────────────
ISO_DIR="$(cd "$(dirname "$0")/.." && pwd)/out"
ISO_FILE=$(ls "$ISO_DIR"/omidenos-*.iso 2>/dev/null | head -n1)

if [[ -z "$ISO_FILE" ]]; then
    err "No OmidenOs ISO found in $ISO_DIR"
    echo -e "  Run ${BOLD}sudo ./scripts/build.sh${N} first."
    exit 1
fi

ISO_SIZE=$(du -h "$ISO_FILE" | awk '{print $1}')
info "ISO found: $(basename "$ISO_FILE") ($ISO_SIZE)"

# ─── List drives ──────────────────────────────────────────────
echo ""
echo -e "  ${C}Available block devices:${N}"
echo ""

# Get root disk to exclude it
ROOT_DISK=$(lsblk -ndo PKNAME "$(df / | tail -1 | awk '{print $1}')" 2>/dev/null || echo "")

lsblk -d -o NAME,SIZE,MODEL,TYPE | grep -v "^loop\|^NAME" | while read -r name size model type; do
    marker=" "
    [[ "$name" == "$ROOT_DISK" ]] && marker="${R}✘${N}(system)"
    [[ -b "/dev/$name" ]] && echo -e "  ${C}$name${N}  ${size}  $model  $marker"
done

echo ""

# ─── Select device ─────────────────────────────────────────────
read -p "  Enter USB device name (e.g. sdb, sdc): " USB_NAME
USB_DEV="/dev/$USB_NAME"

if [[ ! -b "$USB_DEV" ]]; then
    err "Device $USB_DEV not found."
    exit 1
fi

# Prevent flashing system disk
if [[ "$USB_NAME" == "$ROOT_DISK" ]]; then
    err "Cannot flash system disk ($ROOT_DISK)!"
    exit 1
fi

# ─── Confirm ──────────────────────────────────────────────────
echo ""
echo -e "  ${R}${BOLD}⚠ WARNING: ALL DATA ON $USB_DEV WILL BE ERASED! ⚠${N}"
echo -e "  ${W}ISO:${N}   $(basename "$ISO_FILE")"
echo -e "  ${W}Target:${N} $USB_DEV ($(lsblk -dn -o SIZE "$USB_DEV"))"
echo ""
read -p "  Type 'YES' to confirm: " confirm
[[ "$confirm" == "YES" ]] || { echo "Aborted."; exit 0; }

# ─── Flash ────────────────────────────────────────────────────
echo ""
info "Flashing ISO to $USB_DEV..."
echo ""

dd if="$ISO_FILE" of="$USB_DEV" bs=4M status=progress oflag=sync
sync

echo ""
info "Done! USB is ready to boot OmidenOs."
echo -e "  ${Y}Reboot and boot from USB.${N}"
