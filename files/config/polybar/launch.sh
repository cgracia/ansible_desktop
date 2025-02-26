#!/usr/bin/env bash

# Add this script to your wm startup file.
DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Check if /tmp/MONITOR_info exists, if so source it, else use defaults
if [ -f /tmp/monitor_info.sh ]; then
    source /tmp/monitor_info.sh
    printf "Monitor info loaded from /tmp/monitor_info.sh\n"
else
    MONITOR0='eDP-1'
    MONITOR1='DP-1-1'
    MONITOR2='DP-1-3'
    printf "Monitor info not found, using defaults\n"
fi

printf "MONITOR0: $MONITOR0\n"
printf "MONITOR1: $MONITOR1\n"
printf "MONITOR2: $MONITOR2\n"

# Check if monitor2 is set as env var, if so use it
if [ -n "$MONITOR2" ]; then
    MONITOR=$MONITOR2 polybar top &
    MONITOR=$MONITOR2 polybar bottom &
    MONITOR=$MONITOR1 polybar extra2 &
    MONITOR=$MONITOR0 polybar extra1 &
else
    MONITOR=$MONITOR0 polybar top &
    MONITOR=$MONITOR0 polybar bottom &
fi
