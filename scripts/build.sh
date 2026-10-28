#!/bin/bash
# OmidenOs - ISO Build Script
# GitHub: https://github.com/muhemmed0634/OmidenOs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$PROJECT_DIR/archiso-profile"
BUILD_DIR="$PROJECT_DIR/build"
OUT_DIR="$PROJECT_DIR/out"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════╗"
echo "║     OmidenOs ISO Build Script         ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Check root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[ERROR]${NC} Must be run as root: sudo ./scripts/build.sh"
    exit 1
fi

# Check archiso
if ! command -v mkarchiso &>/dev/null; then
    echo -e "${YELLOW}[WARN]${NC} archiso not found. Installing..."
    pacman -Sy --noconfirm archiso
fi

# Clean old build
echo -e "${GREEN}[INFO]${NC} Cleaning previous build artifacts..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$OUT_DIR"

# Fix permissions
chmod +x "$PROFILE_DIR/airootfs/usr/local/bin/install-omiden"
chmod +x "$PROFILE_DIR/airootfs/usr/local/bin/omiden-welcome"
chmod +x "$PROFILE_DIR/airootfs/root/.automated_script.sh"
chmod 750 "$PROFILE_DIR/airootfs/root"
chmod 400 "$PROFILE_DIR/airootfs/etc/shadow" 2>/dev/null || true

echo -e "${GREEN}[INFO]${NC} Building OmidenOs ISO..."
echo -e "${YELLOW}[INFO]${NC} This will take 10-30 minutes depending on your connection."
echo ""

# Build
mkarchiso -v -w "$BUILD_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo -e "${GREEN}${BOLD}✓ Build complete!${NC}"
echo -e "${CYAN}  ISO saved to: ${OUT_DIR}/${NC}"
ls -lh "$OUT_DIR"/*.iso 2>/dev/null || echo "  (check $OUT_DIR)"
echo ""
echo -e "${YELLOW}  Flash to USB:${NC}"
echo -e "  dd if=$OUT_DIR/omidenos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync"
echo -e "  (replace /dev/sdX with your USB drive)"
