#!/bin/bash
# pomodoro_status.sh
# This script queries the Pomodoro daemon and prints the current status for polybar.

SOCKET="/tmp/pomodoro.sock"

# Check if the daemon's socket exists (i.e., the daemon is running)
if [ ! -S "$SOCKET" ]; then
    echo " Idle"
    exit 0
fi

# Query the daemon for status using socat
status=$(echo "status" | socat - UNIX-CONNECT:"$SOCKET" 2>/dev/null)

# Check if we got a valid response, otherwise report an error.
if [ -z "$status" ]; then
    echo " Error"
else
    echo " $status"
fi
