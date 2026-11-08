#!/bin/bash
# Omiden OS - Pre-Build Check Script
# Checks if everything is ready for ISO build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="$PROJECT_DIR/archiso-profile"

G='\033[0;32m' R='\033[0;31m' Y='\033[1;33m' N='\033[0m' B='\033[1m'

info() { echo -e "  ${G}[✔]${N} $*"; }
warn() { echo -e "  ${Y}[!]${N} $*"; }
err()  { echo -e "  ${R}[✘]${N} $*"; }

echo -e "${B}Omiden OS - Pre-Build Checklist${N}\n"

ISSUES=0

# Check 1: Root access
echo "1. Checking permissions..."
if [[ $EUID -eq 0 ]]; then
    info "Running as root ✓"
else
    warn "Not root (will need sudo for build)"
fi

# Check 2: archiso
echo -e "\n2. Checking archiso..."
if command -v mkarchiso &>/dev/null; then
    info "archiso installed: $(mkarchiso --version 2>&1 | head -1)"
else
    err "archiso NOT installed"
    echo "    Install: sudo pacman -S archiso"
    ((ISSUES++))
fi

# Check 3: Python
echo -e "\n3. Checking Python..."
if command -v python3 &>/dev/null; then
    info "python3: $(python3 --version)"
else
    err "python3 NOT installed"
    ((ISSUES++))
fi

# Check 4: archiso-profile structure
echo -e "\n4. Checking archiso-profile..."
if [[ -d "$PROFILE_DIR" ]]; then
    info "archiso-profile directory exists"
    
    # Check key files
    if [[ -f "$PROFILE_DIR/packages.x86_64" ]]; then
        PKG_COUNT=$(grep -v "^#" "$PROFILE_DIR/packages.x86_64" | grep -v "^$" | wc -l)
        info "packages.x86_64: $PKG_COUNT packages"
    else
        err "packages.x86_64 missing!"
        ((ISSUES++))
    fi
    
    if [[ -f "$PROFILE_DIR/profiledef.sh" ]]; then
        info "profiledef.sh exists"
    else
        err "profiledef.sh missing!"
        ((ISSUES++))
    fi
    
    if [[ -f "$PROFILE_DIR/airootfs/usr/local/bin/omiden-installer" ]]; then
        info "omiden-installer exists"
    else
        warn "omiden-installer missing (optional)"
    fi
else
    err "archiso-profile directory NOT found!"
    ((ISSUES++))
fi

# Check 5: Disk space
echo -e "\n5. Checking disk space..."
FREE_GB=$(df -BG /var/tmp 2>/dev/null | awk 'NR==2{print $4}' | tr -d 'G' || echo "0")
if (( FREE_GB >= 15 )); then
    info "Free space: ${FREE_GB}GB (sufficient)"
elif (( FREE_GB >= 10 )); then
    warn "Free space: ${FREE_GB}GB (might be tight)"
else
    err "Free space: ${FREE_GB}GB (need at least 15GB)"
    ((ISSUES++))
fi

# Check 6: Internet connection
echo -e "\n6. Checking internet..."
if ping -c 1 -W 2 archlinux.org &>/dev/null; then
    info "Internet connection OK"
else
    warn "Cannot reach archlinux.org (might cause issues)"
fi

# Check 7: Package cache
echo -e "\n7. Checking package cache..."
CACHE_SIZE=$(du -sh /var/cache/pacman/pkg 2>/dev/null | awk '{print $1}' || echo "0")
info "Package cache: $CACHE_SIZE"

# Summary
echo -e "\n${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
if (( ISSUES == 0 )); then
    echo -e "${G}${B}✓ All checks passed! Ready to build.${N}"
    echo -e "\nRun: ${B}sudo bash scripts/build.sh${N}"
else
    echo -e "${R}${B}✘ Found $ISSUES issue(s). Fix them first.${N}"
    exit 1
fi
echo -e "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}\n"
