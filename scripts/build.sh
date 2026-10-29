#!/bin/bash
# ============================================================
# OmidenOs - ISO Build Script
# GitHub: https://github.com/muhemmed0634/OmidenOs
# Usage: sudo ./scripts/build.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$PROJECT_DIR/archiso-profile"
WORK_DIR="/var/tmp/omiden-build"
OUT_DIR="$PROJECT_DIR/out"

R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m'
C='\033[0;36m' M='\033[0;35m' W='\033[1;37m' N='\033[0m' BOLD='\033[1m'

echo -e "${M}${BOLD}"
echo "╔═══════════════════════════════════════╗"
echo "║     OmidenOs ISO Build Script         ║"
echo "║   github.com/muhemmed0634/OmidenOs   ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${N}"

info()  { echo -e "  ${G}[✔]${N} $*"; }
warn()  { echo -e "  ${Y}[!]${N} $*"; }
err()   { echo -e "  ${R}[✘]${N} $*"; }
step()  { echo -e "\n${C}${BOLD}━━━ $* ━━━${N}\n"; }

# ─── Check root ───────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    err "Must be run as root: sudo ./scripts/build.sh"
    exit 1
fi

# ─── Check archiso ────────────────────────────────────────────
if ! command -v mkarchiso &>/dev/null; then
    warn "archiso not found. Installing..."
    pacman -Sy --noconfirm archiso
fi
info "archiso: $(mkarchiso --version 2>/dev/null || echo 'installed')"

# ─── Fix permissions ──────────────────────────────────────────
step "Fixing file permissions"
chmod +x "$PROFILE_DIR"/airootfs/usr/local/bin/* 2>/dev/null
chmod +x "$PROFILE_DIR"/airootfs/root/.automated_script.sh 2>/dev/null
chmod 750 "$PROFILE_DIR"/airootfs/root 2>/dev/null
chmod 400 "$PROFILE_DIR"/airootfs/etc/shadow 2>/dev/null || true
info "Permissions fixed."

# ─── Clean old build ──────────────────────────────────────────
step "Cleaning previous build artifacts"
# Unmount any leftover mounts from previous failed builds
if [[ -d "$WORK_DIR" ]]; then
    umount -R "$WORK_DIR" 2>/dev/null || true
    rm -rf "$WORK_DIR"
fi
mkdir -p "$WORK_DIR" "$OUT_DIR"
info "Clean done."

# ─── Build ────────────────────────────────────────────────────
step "Building OmidenOs ISO"
echo -e "  ${Y}This will take 10-30 minutes.${N}"
echo -e "  ${Y}Work dir: $WORK_DIR${N}"
echo -e "  ${Y}Output:   $OUT_DIR${N}"
echo ""

# Retry on download failures (BlackArch mirrors can be flaky)
MAX_RETRIES=3
for attempt in $(seq 1 $MAX_RETRIES); do
    if mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"; then
        break
    fi
    if [[ $attempt -eq $MAX_RETRIES ]]; then
        err "Build failed after $MAX_RETRIES attempts."
        echo ""
        echo -e "  ${Y}Common fixes:${N}"
        echo -e "  • Check internet connection"
        echo -e "  • Run: sudo pacman -Syy"
        echo -e "  • If a package fails to download, edit:"
        echo -e "    archiso-profile/packages.x86_64"
        exit 1
    fi
    warn "Build attempt $attempt failed, retrying..."
    sleep 5
done

# ─── Done ─────────────────────────────────────────────────────
echo ""
step "Build Complete!"
echo -e "  ${G}${BOLD}✓${N} ISO saved to: ${C}${OUT_DIR}/${N}"
ls -lh "$OUT_DIR"/*.iso 2>/dev/null || warn "ISO not found in output dir."

echo ""
echo -e "  ${Y}Flash to USB:${NC}"
echo -e "  ${BOLD}sudo ./scripts/flash-usb.sh${N}"
echo -e "  ${BOLD}dd if=$OUT_DIR/omidenos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync${N}"
echo ""
