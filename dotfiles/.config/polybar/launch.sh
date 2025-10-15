#!/bin/bash

CONFIG="$HOME/.config/polybar/config.ini"

# Terminate already running bars
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch
polybar -q main -c "$CONFIG"