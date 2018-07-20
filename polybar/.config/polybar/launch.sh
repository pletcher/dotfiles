#!/usr/bin/env sh

# Terminate already running bars
killall -q polybar

# Wait until they're really terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch top bar
polybar topbar &
echo "bar/topbar launched"
