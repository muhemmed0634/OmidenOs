#!/usr/bin/env bash
# Omiden OS - Polybar Launch Script

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
