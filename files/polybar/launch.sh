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
    MONITOR1='DP-3'
    MONITOR2='DP-2'
    printf "Monitor info not found, using defaults\n"
fi

printf "MONITOR0: $MONITOR0\n"
printf "MONITOR1: $MONITOR1\n"
printf "MONITOR2: $MONITOR2\n"

#Launch Polybar for specific monitors
if xrandr | grep -q "$MONITOR2 connected"; then
    MONITOR=$MONITOR2 polybar top &
    MONITOR=$MONITOR2 polybar bottom &
fi

if xrandr | grep -q "$MONITOR1 connected"; then
    MONITOR=$MONITOR1 polybar extra2 &
fi

if xrandr | grep -q "$MONITOR0 connected"; then
    MONITOR=$MONITOR0 polybar extra1 &
fi
