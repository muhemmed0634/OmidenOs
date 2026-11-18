#!/usr/bin/env bash
# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# Runs inside the airootfs after package installation. Files owned by
# packages cannot be placed in the airootfs overlay (mkarchiso copies
# the overlay before pacman runs and pacman rejects the file conflict),
# so the identity files, the Plymouth theme selection and the live
# user's dotfiles are written here.
# mkarchiso 92 still executes this script, but marks it deprecated;
# revisit this mechanism when archiso removes support for it.

set -euo pipefail

cat >/usr/lib/os-release <<'EOF'
NAME="OmidenOS"
PRETTY_NAME="OmidenOS"
ID=omidenos
VERSION_ID="2026.11"
VERSION="2026.11 (Live)"
BUILD_ID="2026.11.17"
ANSI_COLOR="1;35"
HOME_URL="https://github.com/muhemmed0634/OmidenOs"
DOCUMENTATION_URL="https://github.com/muhemmed0634/OmidenOs/tree/main/docs"
SUPPORT_URL="https://github.com/muhemmed0634/OmidenOs/issues"
BUG_REPORT_URL="https://github.com/muhemmed0634/OmidenOs/issues"
LOGO=omidenos-logo
EOF

# Console font: the kernel default is hard to read on a modern panel.
cat >/etc/vconsole.conf <<'EOF'
KEYMAP=us
FONT=ter-v22b
EOF

# The live medium keeps upstream's "uninitialized" machine-id (mkarchiso
# rewrites it in _cleanup_pacstrap_dir after this script runs), so the
# first-boot unit is masked via the airootfs overlay at
# etc/systemd/system/systemd-firstboot.service. Without that mask the
# unit opens an interactive setup prompt on tty1, covering the live
# session with upstream-branded text.

# Neutralize the upstream package-manager account description that is
# visible in /etc/passwd on the live system.
sed -E -i 's/^(alpm:x:970:970:)[^:]*:/\1Package Management:/' /etc/passwd

# Boot splash (ADR-0011). The theme itself is part of the airootfs
# overlay; the daemon has to be told which theme to load, and that file
# belongs to the plymouth package, so it is written here. ShowDelay=0
# puts the artwork on screen at once instead of after the default delay.
cat >/etc/plymouth/plymouthd.conf <<'EOF'
[Daemon]
Theme=omidenos
ShowDelay=0
EOF

# Live user home. mkarchiso does not create per-user homes, and
# /etc/skel belongs to the shell configuration package, so the session
# files are written directly. XFCE keeps its defaults in xfconf channels
# under ~/.config; the files below pre-seed the panel, the window manager
# and the wallpaper so the session starts configured and without the
# first-start dialog.
install -d -o omiden -g omiden -m 0755 /home/omiden
install -d -o omiden -g omiden -m 0755 /home/omiden/.config
install -d -o omiden -g omiden -m 0755 /home/omiden/.config/autostart
install -d -o omiden -g omiden -m 0755 \
	/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml

cat >/home/omiden/.zshrc <<'EOF'
# OmidenOS live session. The global configuration comes from the shell
# package; this file adds the live extras and has to stay at the end of
# the chain so the plugins load after completion setup.

if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -o login ]] && (( $+commands[fastfetch] )); then
  fastfetch --config /etc/fastfetch/config.jsonc
fi
EOF

# One top panel: the project menu, the window list, the notification
# area, the mixer and the clock. Providing the channel file is also what
# suppresses the panel's first-start dialog on a medium where the live
# user has never logged in before.
cat >/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="configdir" type="string" value=""/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="double" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="34"/>
      <property name="mode" type="uint" value="0"/>
      <property name="autohide-behavior" type="uint" value="0"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-rgba" type="array">
        <value type="double" value="0.023529"/>
        <value type="double" value="0.007843"/>
        <value type="double" value="0.058824"/>
        <value type="double" value="0.94"/>
      </property>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whiskermenu">
      <property name="button-icon" type="string" value="/usr/share/icons/hicolor/48x48/apps/omidenos-logo.png"/>
      <property name="button-title" type="string" value="OmidenOS"/>
      <property name="show-button-title" type="bool" value="true"/>
    </property>
    <property name="plugin-2" type="string" value="tasklist">
      <property name="show-labels" type="bool" value="true"/>
      <property name="grouping" type="bool" value="true"/>
      <property name="flat-buttons" type="bool" value="true"/>
    </property>
    <property name="plugin-3" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-4" type="string" value="systray">
      <property name="square-icons" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="22"/>
    </property>
    <property name="plugin-5" type="string" value="pulseaudio">
      <property name="enable-keyboard-shortcuts" type="bool" value="true"/>
    </property>
    <property name="plugin-6" type="string" value="clock">
      <property name="digital-layout" type="uint" value="3"/>
      <property name="digital-time-format" type="string" value="%H:%M"/>
      <property name="digital-time-font" type="string" value="Sans 11"/>
    </property>
  </property>
</channel>
EOF

# Window manager: the stock theme, four named workspaces and centred
# titles, so the session looks the same on every machine. The titlebar
# colour is the theme's; accenting it needs a custom xfwm4 theme, which is
# a v1.1 item (docs/adr/0012-palette.md).
cat >/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Default"/>
    <property name="title_font" type="string" value="Sans Bold 10"/>
    <property name="title_alignment" type="string" value="center"/>
    <property name="workspace_count" type="int" value="4"/>
    <property name="workspace_names" type="array">
      <value type="string" value="main"/>
      <value type="string" value="web"/>
      <value type="string" value="tools"/>
      <value type="string" value="notes"/>
    </property>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="true"/>
  </property>
</channel>
EOF

# Wallpaper on the single-monitor path. Multi-monitor layouts create
# their own backdrop entries at runtime; omidenos-session fills those in
# on every login, because their names are only known once xfdesktop has
# probed the display.
cat >/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/omidenos/wallpaper.png"/>
          <property name="image-path" type="string" value="/usr/share/backgrounds/omidenos/wallpaper.png"/>
          <property name="image-style" type="int" value="5"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# GTK appearance: the dark variant of the stock theme, the stock icon
# set, and antialiasing with subpixel hinting. No theme is taken from
# outside the medium.
cat >/home/omiden/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Adwaita-dark"/>
    <property name="IconThemeName" type="string" value="Adwaita"/>
  </property>
  <property name="Xft" type="empty">
    <property name="Antialias" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
</channel>
EOF

# The session helper fills in the wallpaper properties XFCE creates at
# runtime; XFCE is the only session, so the entry is unconditional.
cat >/home/omiden/.config/autostart/omidenos-session.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=OmidenOS session setup
Exec=/usr/local/bin/omidenos-session
OnlyShowIn=XFCE;
NoDisplay=true
EOF

chown -R omiden:omiden /home/omiden

# The sddm package installs a Qt5-linked /usr/bin/sddm-greeter next to the
# Qt6 one, and this medium carries no Qt5: that binary dies with
# "libQt5Quick.so.5: cannot open shared object file" and SDDM leaves tty1
# black instead of a login card (seen on the 2026-11-18 build). Point the
# unversioned name at the Qt6 build, so whichever name SDDM launches is a
# greeter that can actually load. The theme itself renders under
# sddm-greeter-qt6 (test-mode run in the live session).
if [ -x /usr/bin/sddm-greeter-qt6 ]; then
	ln -sf /usr/bin/sddm-greeter-qt6 /usr/bin/sddm-greeter
fi

# The kernel package already built an initramfs, before this script ran,
# so the Plymouth hook and the theme are missing from it. Rebuild it now
# that /etc/plymouth/plymouthd.conf points at the theme in the overlay;
# mkarchiso copies /boot out of the airootfs after this step.
mkinitcpio -P
