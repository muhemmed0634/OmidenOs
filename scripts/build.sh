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
LOG_FILE="/var/tmp/omiden-build.log"

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
if ! command -v mkfs.erofs &>/dev/null; then
    warn "erofs-utils not found. Installing..."
    pacman -Sy --noconfirm erofs-utils
fi
info "archiso: $(mkarchiso --version 2>/dev/null || echo 'installed')"

# ─── Check disk space ────────────────────────────────────────
step "Checking disk space"
FREE_GB=$(df -BG /var/tmp | awk 'NR==2{print $4}' | tr -d 'G')
if (( FREE_GB < 10 )); then
    err "Not enough disk space! Need 10GB, have ${FREE_GB}GB on /var/tmp"
    exit 1
fi
info "Free space: ${FREE_GB}GB"

# ─── Fix permissions ──────────────────────────────────────────
step "Fixing file permissions"
chmod +x "$PROFILE_DIR"/airootfs/usr/local/bin/* 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.automated_script.sh 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.xinitrc 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.config/openbox/autostart 2>/dev/null || true
chmod 750 "$PROFILE_DIR"/airootfs/root 2>/dev/null || true
info "Permissions fixed."

# ─── Clean old build ──────────────────────────────────────────
step "Cleaning previous build artifacts"
if [[ -d "$WORK_DIR" ]]; then
    umount -R "$WORK_DIR" 2>/dev/null || true
    rm -rf "$WORK_DIR"
fi
mkdir -p "$WORK_DIR" "$OUT_DIR"
rm -f "$LOG_FILE"
info "Clean done."

# ─── Build ────────────────────────────────────────────────────
step "Building OmidenOs ISO"
echo -e "  ${Y}This will take 5-15 minutes.${N}"
echo -e "  ${Y}Work dir: $WORK_DIR${N}"
echo -e "  ${Y}Output:   $OUT_DIR${N}"
echo -e "  ${Y}Log file: $LOG_FILE${N}"
echo ""

MAX_RETRIES=3
BUILD_OK=false

for attempt in $(seq 1 $MAX_RETRIES); do
    info "Build attempt $attempt/$MAX_RETRIES..."

    if mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR" 2>&1 | tee "$LOG_FILE"; then
        BUILD_OK=true
        break
    fi

    if [[ $attempt -lt $MAX_RETRIES ]]; then
        warn "Attempt $attempt failed. Cleaning and retrying in 5s..."
        # Clean work dir between retries
        umount -R "$WORK_DIR" 2>/dev/null || true
        rm -rf "$WORK_DIR"
        mkdir -p "$WORK_DIR"
        sleep 5
    fi
done

if [[ "$BUILD_OK" != true ]]; then
    err "Build failed after $MAX_RETRIES attempts."
    echo ""
    echo -e "  ${Y}Last errors from log:${N}"
    grep -i "error\|failed\|cannot" "$LOG_FILE" 2>/dev/null | tail -10
    echo ""
    echo -e "  ${Y}Common fixes:${N}"
    echo -e "  • Check internet: ping omidenos.org"
    echo -e "  • Sync repos:    sudo pacman -Syy"
    echo -e "  • Check space:   df -h /var/tmp"
    echo -e "  • Full log:      cat $LOG_FILE"
    echo -e "  • Edit packages: archiso-profile/packages.x86_64"
    exit 1
fi

# ─── Done ─────────────────────────────────────────────────────
echo ""
step "Build Complete!"
echo -e "  ${G}${BOLD}✓${N} ISO saved to: ${C}${OUT_DIR}/${N}"
ls -lh "$OUT_DIR"/*.iso 2>/dev/null || warn "ISO not found in output dir."

echo ""
echo -e "  ${Y}Flash to USB:${N}"
echo -e "  ${BOLD}sudo ./scripts/flash-usb.sh${N}"
echo ""

# ─── Cleanup ──────────────────────────────────────────────────
step "Cleaning up"
umount -R "$WORK_DIR" 2>/dev/null || true
rm -rf "$WORK_DIR"
info "Work directory removed."
echo -e "  ${C}Done!${N}"
