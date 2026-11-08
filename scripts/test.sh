#!/bin/bash
# Omiden OS - Test Script
# Tests the ISO in QEMU (BIOS and UEFI)

set -euo pipefail

# Colors
G='\033[0;32m' Y='\033[1;33m' C='\033[0;36m' N='\033[0m' B='\033[1m'

info() { echo -e "  ${G}[✔]${N} $*"; }
warn() { echo -e "  ${Y}[!]${N} $*"; }

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$BASE_DIR/out"
ISO_FILE=$(find "$OUT_DIR" -name "*.iso" 2>/dev/null | head -1)

[[ -f "$ISO_FILE" ]] || { echo "ERROR: No ISO found in $OUT_DIR"; exit 1; }

echo -e "${C}${B}Omiden OS - ISO Test${N}\n"
info "ISO: $(basename "$ISO_FILE")"

# Check if run_archiso exists
if command -v run_archiso &>/dev/null; then
    echo -e "\n==> Testing with run_archiso (from archiso package)..."
    
    echo -e "\n${C}Testing BIOS mode:${N}"
    run_archiso -i "$ISO_FILE" -b || warn "BIOS test failed"
    
    if [[ -f /usr/share/edk2-ovmf/x64/OVMF.fd ]]; then
        echo -e "\n${C}Testing UEFI mode:${N}"
        run_archiso -i "$ISO_FILE" -u || warn "UEFI test failed"
    else
        warn "OVMF not found, skipping UEFI test"
        warn "Install with: sudo pacman -S edk2-ovmf"
    fi
else
    echo -e "\n==> Manual QEMU test..."
    
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo "ERROR: qemu not installed"
        echo "Install with: sudo pacman -S qemu-full"
        exit 1
    fi
    
    echo -e "\n${C}Starting QEMU (BIOS mode)...${N}"
    echo "Press Ctrl+Alt+G to release mouse, Ctrl+Alt+Q to quit"
    
    qemu-system-x86_64 \
        -cdrom "$ISO_FILE" \
        -m 2048 \
        -smp 2 \
        -enable-kvm \
        -boot d \
        -vga virtio \
        -display sdl
fi

info "Test complete!"
