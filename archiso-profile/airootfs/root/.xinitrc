#!/bin/sh
# OmidenOs .xinitrc

# Load Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Set keyboard
setxkbmap us &

# Start Openbox
exec openbox-session
