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

info()  { echo -e "  ${G}[✔]${N} $*"; }
warn()  { echo -e "  ${Y}[!]${N} $*"; }
err()   { echo -e "  ${R}[✘]${N} $*"; }
step()  { echo -e "\n${C}${BOLD}━━━ $* ━━━${N}\n"; }

echo -e "${M}${BOLD}"
echo "╔═══════════════════════════════════════╗"
echo "║     OmidenOs  ISO Build Script        ║"
echo "║   github.com/muhemmed0634/OmidenOs    ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${N}"

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

# ─── Check Python ─────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
    warn "python3 not found. Installing..."
    pacman -S --noconfirm python python-yaml
fi
info "python3: $(python3 --version 2>/dev/null)"

# ─── Predict ISO filename ─────────────────────────────────────
ISO_DATE="$(date +%Y.%m.%d)"
ISO_NAME="omiden"
PREDICTED_ISO="${ISO_NAME}-${ISO_DATE}-x86_64.iso"
echo ""
echo -e "  ${W}Expected ISO name:${N} ${BOLD}${PREDICTED_ISO}${N}"
echo -e "  ${W}Output directory:${N}  ${C}${OUT_DIR}/${N}"
echo ""

# ─── Check disk space ─────────────────────────────────────────
step "Checking disk space"
FREE_GB=$(df -BG /var/tmp | awk 'NR==2{print $4}' | tr -d 'G')
if (( FREE_GB < 15 )); then
    err "Not enough space! Need 15GB, have ${FREE_GB}GB on /var/tmp"
    exit 1
fi
info "Free space on /var/tmp: ${FREE_GB}GB ✓"

# ─── Force full clean ─────────────────────────────────────────
step "Cleaning old build artifacts"
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
echo -e "  ${Y}ISO name:   ${BOLD}${PREDICTED_ISO}${N}"
echo -e "  ${Y}Work dir:   $WORK_DIR${N}"
echo -e "  ${Y}Output:     $OUT_DIR${N}"
echo -e "  ${Y}Log:        $LOG_FILE${N}"
echo -e "  ${Y}Estimated time: 15-30 minutes${N}"
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
        warn "Attempt $attempt failed. Cleaning and retrying in 10s..."
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
    echo -e "  ${Y}Common fixes:${N}"
    echo -e "  • Check internet:  ping archlinux.org"
    echo -e "  • Sync repos:      sudo pacman -Syy"
    echo -e "  • Check space:     df -h /var/tmp"
    echo -e "  • Full log:        cat $LOG_FILE | grep -i error"
    exit 1
fi

# ─── Verify ISO ───────────────────────────────────────────────
step "Verifying ISO"
ISO_FILE=$(ls -t "$OUT_DIR"/omiden-*.iso 2>/dev/null | head -1)
if [[ -z "$ISO_FILE" ]]; then
    err "ISO not found in $OUT_DIR"
    err "Expected: $OUT_DIR/$PREDICTED_ISO"
    exit 1
fi

ISO_SIZE=$(du -h "$ISO_FILE" | awk '{print $1}')
ISO_GB=$(du -BG "$ISO_FILE" | awk '{print $1}' | tr -d 'G')
info "ISO: ${BOLD}$(basename "$ISO_FILE")${N}  ($ISO_SIZE)"

# Sanity check
if (( ISO_GB > 8 )); then
    warn "ISO is ${ISO_GB}GB — too large, build may have included wrong files!"
    warn "Check: $LOG_FILE"
elif (( ISO_GB < 1 )); then
    warn "ISO is ${ISO_GB}GB — too small, build may have failed silently!"
else
    info "ISO size: ${ISO_SIZE} — looks correct ✓"
fi

# ─── Done ─────────────────────────────────────────────────────
echo ""
step "Build Complete!"
echo -e ""
echo -e "  ${G}${BOLD}✓ ISO Ready${N}"
echo -e "  ${W}Name:${N}   ${BOLD}$(basename "$ISO_FILE")${N}"
echo -e "  ${W}Size:${N}   ${ISO_SIZE}"
echo -e "  ${W}Path:${N}   ${C}$ISO_FILE${N}"
echo ""
echo -e "  ${Y}Write to USB:${N}"
echo -e "  ${BOLD}sudo dd if=$ISO_FILE of=/dev/sdX bs=4M status=progress oflag=sync${N}"
echo ""
echo -e "  ${Y}Or use:${N}"
echo -e "  • Ventoy (recommended): https://www.ventoy.net"
echo -e "  • Balena Etcher: https://www.balena.io/etcher"
echo -e "  • Rufus (Windows): https://rufus.ie"
echo ""
echo -e "  ${Y}Test in QEMU:${N}"
echo -e "  ${BOLD}bash scripts/test.sh $ISO_FILE${N}"
echo ""

# ─── Cleanup work dir ─────────────────────────────────────────
umount -R "$WORK_DIR" 2>/dev/null || true
rm -rf "$WORK_DIR"
info "Work directory cleaned."
