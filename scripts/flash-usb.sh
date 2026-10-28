#!/bin/bash
# OmidenOs - Flash ISO to USB

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Must be run as root${NC}"
    exit 1
fi

ISO_DIR="$(dirname "$0")/../out"
ISO_FILE=$(ls "$ISO_DIR"/omidenos-*.iso 2>/dev/null | head -n1)

if [[ -z "$ISO_FILE" ]]; then
    echo -e "${RED}No OmidenOs ISO found in $ISO_DIR${NC}"
    echo "Run ./scripts/build.sh first."
    exit 1
fi

echo -e "${CYAN}Available USB drives:${NC}"
lsblk -d -o NAME,SIZE,MODEL | grep -v "loop\|sda" || lsblk -d -o NAME,SIZE,MODEL | grep -v "loop"
echo ""
read -p "Enter USB device (e.g. sdb): " USB_DEV
USB_DEV="/dev/$USB_DEV"

if [[ ! -b "$USB_DEV" ]]; then
    echo -e "${RED}Device $USB_DEV not found${NC}"
    exit 1
fi

echo -e "${YELLOW}WARNING: All data on $USB_DEV will be erased!${NC}"
echo -e "ISO: $ISO_FILE -> $USB_DEV"
read -p "Confirm? [y/N]: " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && exit 0

echo -e "${GREEN}Flashing...${NC}"
dd if="$ISO_FILE" of="$USB_DEV" bs=4M status=progress oflag=sync
sync

echo -e "${GREEN}Done! USB is ready to boot OmidenOs.${NC}"
