# Part 4: Dotfiles and Website - Complete

## What Was Created

### 1. Dotfiles Structure

```
dotfiles/
├── common/                       # Shared configs for all WMs
│   ├── .zshrc                   # ZSH with modern tools
│   ├── .config/
│   │   ├── alacritty/
│   │   │   └── alacritty.toml   # Terminal emulator
│   │   ├── nvim/
│   │   │   └── init.lua         # Neovim config
│   │   └── starship.toml        # Shell prompt
├── hyprland/                     # Hyprland (Wayland) specific
│   └── .config/
│       ├── hypr/
│       │   ├── hyprland.conf    # Main config with keybinds
│       │   └── hyprpaper.conf   # Wallpaper daemon
│       └── waybar/
│           ├── config           # Top bar modules
│           └── style.css        # Catppuccin theme
└── i3/                          # i3 (X11) specific
    └── .config/
        ├── i3/
        │   └── config           # WM config with keybinds
        ├── polybar/
        │   ├── config.ini       # Top bar config
        │   └── launch.sh        # Startup script
        └── rofi/
            └── config.rasi      # Application launcher
```

### 2. Common Dotfiles Features

**Shell (.zshrc):**
- Starship prompt (fast, customizable)
- Modern tool aliases: `ls` → `eza`, `cat` → `bat`, `grep` → `rg`
- Zoxide for smart directory jumping
- Git aliases (gs, ga, gc, gp, gl)
- History search and autosuggestions
- Syntax highlighting

**Terminal (Alacritty):**
- Catppuccin Mocha color scheme
- JetBrainsMono Nerd Font
- 95% opacity for blur effects
- Optimized padding

**Editor (Neovim):**
- Line numbers (relative + absolute)
- Smart case search
- Modern keybinds (Space as leader)
- Window navigation (Ctrl+hjkl)
- Auto-trim trailing whitespace
- Highlight on yank

### 3. Hyprland Dotfiles

**hyprland.conf:**
- Dual keyboard layout (US + AZ, Alt+Shift to toggle)
- Rounded corners (10px) with blur
- Smooth animations (bezier curves)
- Gaps: 5px inner, 10px outer
- Dual-tone border (blue + pink gradient)
- Super key as mod
- All 60+ keybinds from keybinds.yml
- Auto-start: waybar, hyprpaper, dunst, nm-applet

**Waybar:**
- Top bar with workspace indicators
- Modules: CPU, Memory, Battery, Network, Volume, Clock
- Catppuccin colors
- Click actions (pavucontrol for volume, nm-connection-editor for network)

**Hyprpaper:**
- Default wallpaper: ~/Pictures/Wallpapers/normal/default.jpg
- Easy to customize

### 4. i3 Dotfiles

**i3 config:**
- Same layout structure as Hyprland
- Tiling + floating modes
- Picom compositor for transparency
- All 60+ keybinds (mapped from keybinds.yml)
- Auto-start: polybar, picom, dunst, nm-applet, feh (wallpaper)
- Window borders: 2px with catppuccin colors
- Gaps: 10px inner, 5px outer

**Polybar:**
- Top bar with i3 workspaces
- Same modules as Waybar
- Catppuccin color scheme
- Icons from Nerd Fonts

**Rofi:**
- Application launcher
- Catppuccin theme
- Rounded corners (10px)
- Shows icons from .desktop files

### 5. Bilingual Website

**Structure:**
```
site/
├── index.html               # Single-page site
├── assets/
│   ├── css/
│   │   └── style.css       # Responsive design, catppuccin theme
│   └── js/
│       └── main.js         # Dynamic content, language switching
└── data/
    ├── tools.json          # 168 tools from tools.yml
    ├── keybinds.json       # 52 keybinds from keybinds.yml
    ├── wallpapers.json     # Wallpaper gallery metadata
    └── release.json        # Latest version info
```

**Features:**
- **Bilingual:** English and Azerbaijani (toggle in top-right)
- **Responsive:** Mobile, tablet, desktop optimized
- **Dark theme:** Catppuccin Mocha colors
- **Sections:**
  - Hero: Download CTA, GitHub link
  - Features: 4-card grid (Performance, Dual WM, 160+ Tools, Bilingual)
  - Tools: Filterable by category (All, CLI, Network, Dev, Desktop)
  - Keybinds: Toggle between Hyprland and i3 keybinds
  - Wallpapers: Gallery with 3 categories (Normal, Dynamic Dark/Light)
  - Download: Latest release with system requirements
- **Dynamic content:** Loaded from JSON files
- **Smooth scroll:** Anchor links scroll smoothly
- **Language persistence:** Choice saved in localStorage

**Design:**
- Modern gradient hero section
- Card-based layouts
- Hover animations (lift on hover)
- Icon badges for stack (common/hyprland/i3)
- Clean typography (Segoe UI fallback)
- High contrast for accessibility

### 6. Installer Updates

**omiden-installer:**
- `copy_dotfiles()` function implemented
- Copies dotfiles based on WM choice:
  - `none`: No dotfiles copied
  - `hyprland`: common + hyprland
  - `i3`: common + i3
  - `both`: common + hyprland + i3
- Creates wallpaper directories:
  - ~/Pictures/Wallpapers/normal
  - ~/Pictures/Wallpapers/dynamic-dark
  - ~/Pictures/Wallpapers/dynamic-light
  - ~/Pictures/Screenshots
- Sets correct ownership ($USERNAME:$USERNAME)

### 7. Scripts

**gen-site-data.py (updated):**
- Parses tools.yml and keybinds.yml without external dependencies
- Generates 4 JSON files:
  - `tools.json`: 168 tools with descriptions in both languages
  - `keybinds.json`: 52 keybinds for Hyprland and i3
  - `wallpapers.json`: Gallery metadata (placeholder until wallpapers fetched)
  - `release.json`: Version, date, download URL

## Theme Consistency

All configs use **Catppuccin Mocha** color palette:
- Background: #1e1e2e (primary), #313244 (secondary)
- Text: #cdd6f4 (primary), #bac2de (secondary)
- Accent: #89b4fa (blue)
- Success: #a6e3a1 (green)
- Warning: #f9e2af (yellow)
- Error: #f38ba8 (red)

## Usage

### For Users

1. **Install Omiden OS** using the installer
2. **Choose WM** (Hyprland/i3/Both) during installation
3. **Dotfiles auto-installed** to your home directory
4. **Login** and enjoy pre-configured environment

### For Developers

```bash
# Generate website data
python3 scripts/gen-site-data.py

# Preview website (needs web server)
cd site
python3 -m http.server 8000
# Visit: http://localhost:8000

# Update dotfiles
# Edit files in dotfiles/common, dotfiles/hyprland, dotfiles/i3
# Then rebuild ISO or rsync to test system
```

## Customization Guide

### Change Colors

**Hyprland:**
- Edit `~/.config/hypr/hyprland.conf`
- Update `col.active_border` and `col.inactive_border`

**Waybar:**
- Edit `~/.config/waybar/style.css`
- Update CSS variables at top

**i3:**
- Edit `~/.config/i3/config`
- Update `client.focused` colors

**Polybar:**
- Edit `~/.config/polybar/config.ini`
- Update `[colors]` section

### Add Keybinds

1. Edit `data/keybinds.yml`
2. Add new keybind entry
3. Run `python3 scripts/gen-site-data.py` (updates website)
4. Manually add to dotfiles:
   - `dotfiles/hyprland/.config/hypr/hyprland.conf`
   - `dotfiles/i3/.config/i3/config`

### Change Wallpaper

**Hyprland:**
```bash
# Edit hyprpaper config
nano ~/.config/hypr/hyprpaper.conf
# Change preload and wallpaper paths
# Reload: killall hyprpaper && hyprpaper &
```

**i3:**
```bash
# Edit i3 config
nano ~/.config/i3/config
# Change feh line
# Reload: i3-msg restart
```

## Next Steps (Part 5)

- [ ] Fetch wallpapers from JaKooLit/Wallpaper-Bank
- [ ] Create CI/CD workflows (GitHub Actions)
- [ ] Test ISO build
- [ ] Deploy website to GitHub Pages
- [ ] Create release with downloadable ISO

## Testing Checklist

**Hyprland:**
- [ ] Waybar shows correctly
- [ ] Keybinds work (Super+Return, Super+D, etc.)
- [ ] Wallpaper loads
- [ ] Terminal uses Alacritty with correct theme
- [ ] ZSH prompt (Starship) appears

**i3:**
- [ ] Polybar shows correctly
- [ ] Keybinds work (Super+Return, Super+D, etc.)
- [ ] Wallpaper loads via feh
- [ ] Rofi launcher themed correctly
- [ ] Picom compositor running

**Website:**
- [ ] Language toggle works
- [ ] Tools filter works
- [ ] Keybinds toggle works
- [ ] Responsive on mobile
- [ ] All links work

## File Count Summary

- Dotfiles: 13 configuration files
- Website: 1 HTML, 1 CSS, 1 JS, 4 JSON
- Total: 20 new files created

## Credits

- **Theme:** Catppuccin (https://github.com/catppuccin)
- **Fonts:** JetBrainsMono Nerd Font
- **Icons:** Nerd Fonts icon set
- **Wallpapers:** JaKooLit/Wallpaper-Bank (to be fetched)
