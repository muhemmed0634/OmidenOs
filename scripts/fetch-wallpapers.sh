#!/bin/bash
# Omiden OS - Wallpaper Fetcher
# Clones JaKooLit/Wallpaper-Bank and organizes wallpapers

set -euo pipefail

REPO_URL="https://github.com/JaKooLit/Wallpaper-Bank.git"
WALLPAPER_DIR="$(dirname "$0")/../wallpapers"
TEMP_CLONE="/tmp/wallpaper-bank-clone"

echo "==> Fetching wallpapers from $REPO_URL"

# Clean previous clone
rm -rf "$TEMP_CLONE"

# Clone with depth 1
if ! git clone --depth 1 "$REPO_URL" "$TEMP_CLONE"; then
    echo "ERROR: Failed to clone wallpaper repository!"
    echo "Please check your internet connection and try again."
    exit 1
fi

# Create target directory
mkdir -p "$WALLPAPER_DIR"

# Detect and copy wallpaper folders
cd "$TEMP_CLONE"

# Find actual folder names (don't hardcode)
NORMAL_DIR=$(find . -maxdepth 1 -type d -iname "wallpaper*" ! -iname "*dynamic*" | head -1)
DARK_DIR=$(find . -maxdepth 1 -type d -iname "*dynamic*dark*" | head -1)
LIGHT_DIR=$(find . -maxdepth 1 -type d -iname "*dynamic*light*" | head -1)

if [[ -z "$NORMAL_DIR" ]]; then
    echo "WARNING: Normal wallpapers folder not found!"
else
    echo "Found normal wallpapers: $NORMAL_DIR"
    mkdir -p "$WALLPAPER_DIR/normal"
    cp -r "$NORMAL_DIR"/* "$WALLPAPER_DIR/normal/" 2>/dev/null || true
fi

if [[ -z "$DARK_DIR" ]]; then
    echo "WARNING: Dark wallpapers folder not found!"
else
    echo "Found dark wallpapers: $DARK_DIR"
    mkdir -p "$WALLPAPER_DIR/dynamic-dark"
    cp -r "$DARK_DIR"/* "$WALLPAPER_DIR/dynamic-dark/" 2>/dev/null || true
fi

if [[ -z "$LIGHT_DIR" ]]; then
    echo "WARNING: Light wallpapers folder not found!"
else
    echo "Found light wallpapers: $LIGHT_DIR"
    mkdir -p "$WALLPAPER_DIR/dynamic-light"
    cp -r "$LIGHT_DIR"/* "$WALLPAPER_DIR/dynamic-light/" 2>/dev/null || true
fi

# Count wallpapers
TOTAL_COUNT=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | wc -l)

echo "==> Wallpapers fetched: $TOTAL_COUNT total"
echo "    Normal: $(find "$WALLPAPER_DIR/normal" -type f 2>/dev/null | wc -l)"
echo "    Dark:   $(find "$WALLPAPER_DIR/dynamic-dark" -type f 2>/dev/null | wc -l)"
echo "    Light:  $(find "$WALLPAPER_DIR/dynamic-light" -type f 2>/dev/null | wc -l)"

# Create CREDITS.md
cat > "$WALLPAPER_DIR/CREDITS.md" << 'EOF'
# Wallpaper Credits

These wallpapers are sourced from [JaKooLit/Wallpaper-Bank](https://github.com/JaKooLit/Wallpaper-Bank).

## Original Sources

The images in this collection belong to their original creators and are sourced from:

- [Alphacoders](https://alphacoders.com/)
- [Wallhaven](https://wallhaven.cc/)
- [Wallpapers-clan](https://wallpapers-clan.com/)

## Usage

These wallpapers are provided for personal use. If you are a copyright holder and would like your work removed, please contact us at:

**Takedown requests:** Open an issue at [github.com/muhemmed0634/OmidenOs/issues](https://github.com/muhemmed0634/OmidenOs/issues)

## Credits

- Wallpaper Bank maintained by: [JaKooLit](https://github.com/JaKooLit)
- Omiden OS: [muhemmed0634](https://github.com/muhemmed0634)

All rights remain with the original artists and photographers.
EOF

echo "==> CREDITS.md created"

# Cleanup
rm -rf "$TEMP_CLONE"

echo "==> Wallpaper fetch complete!"
