#!/usr/bin/env sh

CONFIG="$HOME/.config/polybar/config.ini"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar -q main -c "$CONFIG" &