#!/usr/bin/env bash
# OmidenOs - Automated startup script for live environment

# Start X if not already running
if [[ -z "$DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
    exec startx
fi
