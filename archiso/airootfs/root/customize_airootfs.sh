#!/usr/bin/env bash
# SPDX-FileCopyrightText: OmidenOS project
# SPDX-License-Identifier: BSD-3-Clause
#
# Runs inside the airootfs after package installation. Files owned by
# packages cannot be placed in the airootfs overlay (mkarchiso copies
# the overlay before pacman runs and pacman rejects the file conflict),
# so the identity files and the live user's dotfiles are written here.
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

# Live user home. mkarchiso does not create per-user homes, and
# /etc/skel belongs to the shell configuration package, so the session
# files are written directly. Three session configurations are kept:
# the shell, the X11 tiling window manager and the Wayland compositor.
install -d -o omiden -g omiden -m 0755 /home/omiden
install -d -o omiden -g omiden -m 0755 /home/omiden/.config
install -d -o omiden -g omiden -m 0755 /home/omiden/.config/i3
install -d -o omiden -g omiden -m 0755 /home/omiden/.config/hypr

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

cat >/home/omiden/.config/i3/config <<'EOF'
# OmidenOS live session, i3 defaults.
# Modifier is the Windows key; the workflow is tiling, no desktop icons.

set $mod Mod4
font pango:Noto Sans 10

# Open a terminal, launcher, file manager
bindsym $mod+Return exec xfce4-terminal
bindsym $mod+d exec rofi -show drun
bindsym $mod+Shift+f exec thunar

# Window handling
bindsym $mod+q kill
bindsym $mod+f fullscreen toggle
bindsym $mod+v split v
bindsym $mod+h split h
bindsym $mod+r restart
bindsym $mod+Shift+e exec i3-msg exit

# Focus and move
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Workspaces
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5

# Session actions
bindsym XF86AudioRaiseVolume exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindsym XF86AudioLowerVolume exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindsym XF86AudioMute exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindsym $mod+Shift+p exec systemctl poweroff
bindsym $mod+Shift+l exec i3lock -c 1a1a1a

bar {
    status_command i3status
    position top
    colors {
        background #1a1a1a
        statusline #e6e6e6
        focused_workspace #8b5cf6 #8b5cf6 #ffffff
        inactive_workspace #1a1a1a #1a1a1a #9e9e9e
    }
}
EOF

cat >/home/omiden/.config/hypr/hyprland.conf <<'EOF'
# OmidenOS live session, Hyprland defaults.
# Purple accent follows the crest; everything else stays close to stock
# so the session is readable for someone who has never seen Hyprland.

monitor=,preferred,auto,1

$mod = SUPER

exec-once = waybar
exec-once = nm-applet --indicator

input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(8b5cf6ee) rgba(5eead4ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 8
}

bind = $mod, Return, exec, kitty
bind = $mod, D, exec, wofi --show drun
bind = $mod, Q, killactive
bind = $mod, F, fullscreen
bind = $mod, E, exec, thunar
bind = $mod SHIFT, E, exit
bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, P, exec, systemctl poweroff
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
EOF

chown -R omiden:omiden /home/omiden
