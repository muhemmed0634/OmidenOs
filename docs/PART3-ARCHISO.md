# Part 3: archiso Profile - Complete

## What Was Created

### 1. archiso Profile Structure
```
archiso-profile/
├── airootfs/                      # Root filesystem overlay
│   ├── etc/motd                   # Welcome message
│   └── usr/
│       ├── local/bin/
│       │   └── omiden-installer   # Custom installer (v5.0)
│       └── share/omiden/
│           ├── packages-hyprland.txt   # 15 Hyprland packages
│           ├── packages-i3.txt         # 13 i3 packages
│           └── packages-optional.txt   # 110 optional packages
├── efiboot/                       # UEFI boot configs (from releng)
├── grub/
│   ├── grub.cfg                   # GRUB menu (branded as Omiden OS)
│   └── loopback.cfg
├── syslinux/
│   └── archiso_sys-linux.cfg      # BIOS boot menu (branded)
├── bootstrap_packages             # Bootstrap packages (from releng)
├── packages.x86_64                # 43 base + installer packages
├── packages.aarch64               # ARM64 support (from releng)
├── pacman.conf                    # Pacman configuration
└── profiledef.sh                  # ISO metadata (branded)
```

### 2. Package Organization

**Base System (in ISO) - 43 packages:**
- Critical: base, linux, linux-firmware, grub, networkmanager
- Tools: 30 CLI/network tools from tools.yml
- Installer: dialog, gawk

**WM-Specific (installed by installer):**
- Hyprland: 15 packages (waybar, hyprpaper, rofi-wayland, etc.)
- i3: 13 packages (i3-wm, i3status, i3lock, polybar, etc.)
- Optional: 110 application packages

### 3. Custom Installer Features

**omiden-installer v5.0** includes:
- Network connectivity check
- Disk selection with confirmation dialog
- Auto-detect UEFI/BIOS boot mode
- Automatic partitioning (GPT for UEFI, MBR for BIOS)
- Base system installation
- **Interactive WM selection:**
  - Hyprland (Wayland compositor)
  - i3 (X11 tiling WM)
  - Both (choose at login)
  - None (CLI only)
- System configuration (hostname, locale, timezone)
- GRUB bootloader installation
- User account creation with sudo access
- Logging to `/tmp/omiden-install.log`

### 4. ISO Branding

**Modified files for Omiden OS branding:**
- `profiledef.sh`: ISO name, label, publisher, version
- `grub/grub.cfg`: Boot menu entries
- `syslinux/archiso_sys-linux.cfg`: BIOS boot menu
- `airootfs/etc/motd`: Welcome screen with ASCII art

### 5. Scripts

**scripts/gen-packages.py**
- Parses `data/tools.yml` (no external dependencies)
- Generates archiso package list
- Creates installer package files
- Categorizes by stack (common/hyprland/i3)

## Package Distribution Strategy

1. **ISO contains minimal base**: ~43 packages
   - Just enough to boot and run installer
   - Network tools, essential CLI utilities
   
2. **Installer downloads WM packages**: 15-28 packages
   - User chooses WM during installation
   - Packages downloaded from Arch repos
   
3. **Optional packages**: 110 packages
   - Not installed by default
   - Available in package files for future use

## Build Instructions

```bash
# Generate package lists
python3 scripts/gen-packages.py

# Build ISO (requires root)
sudo bash scripts/build.sh

# Test in QEMU
bash scripts/test.sh out/omidenos-*.iso
```

## Boot Flow

1. **GRUB/Syslinux menu** → Select "Omiden OS Live/Install"
2. **Boot into live environment** → Shows ASCII art motd
3. **Run installer**: `sudo omiden-installer`
4. **Installer flow**:
   - Check network
   - Select disk
   - Partition & format
   - Install base system
   - **Choose WM** (Hyprland/i3/Both/None)
   - Install WM packages
   - Configure system
   - Install bootloader
   - Create user
   - Reboot

## Next Steps (Part 4)

- [ ] Create dotfiles for common/hyprland/i3
- [ ] Copy dotfiles in installer
- [ ] Create bilingual static website
- [ ] Add wallpaper integration
- [ ] Test ISO build
- [ ] CI/CD workflows

## Technical Details

**Boot Modes Supported:**
- UEFI (systemd-boot + GRUB)
- BIOS (syslinux + GRUB)

**Filesystem:**
- UEFI: FAT32 boot, ext4 root
- BIOS: ext4 boot + root

**Default Locale:**
- English (en_US.UTF-8)
- Azerbaijani (az_AZ.UTF-8)

**Default Timezone:**
- Asia/Baku
