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
info "archiso: $(mkarchiso --version 2>/dev/null || echo 'installed')"

# ─── Check disk space ─────────────────────────────────────────
step "Checking disk space"
FREE_GB=$(df -BG /var/tmp | awk 'NR==2{print $4}' | tr -d 'G')
if (( FREE_GB < 15 )); then
    err "Not enough space! Need 15GB, have ${FREE_GB}GB on /var/tmp"
    exit 1
fi
info "Free space on /var/tmp: ${FREE_GB}GB"

# ─── IMPORTANT: Force full clean ──────────────────────────────
step "Force cleaning old build artifacts"
# Unmount any stale mounts
for mnt in proc sys dev run tmp; do
    umount -R "$WORK_DIR/x86_64/airootfs/$mnt" 2>/dev/null || true
done
umount -R "$WORK_DIR" 2>/dev/null || true
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR" "$OUT_DIR"
rm -f "$LOG_FILE"
info "Work directory wiped clean."

# ─── Fix permissions ──────────────────────────────────────────
step "Fixing file permissions"
chmod +x "$PROFILE_DIR"/airootfs/usr/local/bin/* 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.automated_script.sh 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.xinitrc 2>/dev/null || true
chmod +x "$PROFILE_DIR"/airootfs/root/.config/openbox/autostart 2>/dev/null || true
chmod 750 "$PROFILE_DIR"/airootfs/root 2>/dev/null || true
info "Permissions set."

# ─── Build ────────────────────────────────────────────────────
step "Building OmidenOs ISO"
echo -e "  ${Y}This will take 10-20 minutes (squashfs+zstd, 8 cores).${N}"
echo -e "  ${Y}Work dir: $WORK_DIR${N}"
echo -e "  ${Y}Output:   $OUT_DIR${N}"
echo -e "  ${Y}Log:      $LOG_FILE${N}"
echo ""

MAX_RETRIES=2
BUILD_OK=false

for attempt in $(seq 1 $MAX_RETRIES); do
    info "Build attempt $attempt/$MAX_RETRIES..."

    if mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR" 2>&1 | tee "$LOG_FILE"; then
        BUILD_OK=true
        break
    fi

    if [[ $attempt -lt $MAX_RETRIES ]]; then
        warn "Attempt $attempt failed. Full clean and retry in 10s..."
        for mnt in proc sys dev run tmp; do
            umount -R "$WORK_DIR/x86_64/airootfs/$mnt" 2>/dev/null || true
        done
        umount -R "$WORK_DIR" 2>/dev/null || true
        rm -rf "$WORK_DIR"
        mkdir -p "$WORK_DIR"
        sleep 10
    fi
done

if [[ "$BUILD_OK" != true ]]; then
    err "Build failed after $MAX_RETRIES attempts."
    echo ""
    echo -e "  ${Y}Last errors:${N}"
    grep -E "^==> ERROR|^error:" "$LOG_FILE" 2>/dev/null | tail -15
    echo ""
    echo -e "  ${Y}Full log: cat $LOG_FILE | grep -i error${N}"
    exit 1
fi

# ─── Verify ISO ───────────────────────────────────────────────
step "Verifying ISO"
ISO_FILE=$(ls -t "$OUT_DIR"/omidenos-*.iso 2>/dev/null | head -1)
if [[ -z "$ISO_FILE" ]]; then
    err "ISO not found in $OUT_DIR"
    exit 1
fi
ISO_SIZE=$(du -h "$ISO_FILE" | awk '{print $1}')
info "ISO: $(basename "$ISO_FILE") ($ISO_SIZE)"

# Sanity check — 8GB+ means build error
ISO_GB=$(du -BG "$ISO_FILE" | awk '{print $1}' | tr -d 'G')
if (( ISO_GB > 6 )); then
    warn "ISO is ${ISO_GB}GB — suspiciously large! Check $LOG_FILE"
else
    info "ISO size looks correct."
fi

# ─── Done ─────────────────────────────────────────────────────
echo ""
step "Build Complete!"
echo -e "  ${G}${BOLD}✓${N} ${BOLD}$(basename "$ISO_FILE")${N}  —  $ISO_SIZE"
echo -e "  ${C}Saved to: $OUT_DIR${N}"
echo ""
echo -e "  ${Y}Flash to USB:${N}"
echo -e "  ${BOLD}sudo ./scripts/flash-usb.sh${N}"
echo ""

# ─── Cleanup ──────────────────────────────────────────────────
umount -R "$WORK_DIR" 2>/dev/null || true
rm -rf "$WORK_DIR"
info "Work directory cleaned."
