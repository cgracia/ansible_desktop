#!/bin/bash

DEVICE="bluez_card.80_C3_BA_50_05_60"
BATTERY_PATH="/sys/class/power_supply/hci0/devices/80:C3:BA:50:05:60/battery"

# Check if the device is connected
CONNECTED=$(pactl list cards | grep -A 1 $DEVICE | grep "State" | awk '{print $2}')
if [[ "$CONNECTED" != "RUNNING" ]]; then
    echo "🔵🔴 Disconnected"
    exit 0
fi

# Get active profile
CURRENT_PROFILE=$(pactl list cards | grep -A 20 $DEVICE | grep "Active Profile" | awk '{print $3}')

# Get battery status (if available)
if [[ -f $BATTERY_PATH ]]; then
    BATTERY_LEVEL=$(cat $BATTERY_PATH/capacity)
    BATTERY_ICON="🔋$BATTERY_LEVEL%"
else
    BATTERY_ICON="🔋 N/A"
fi

# Output based on profile with Bluetooth rune
if [[ "$CURRENT_PROFILE" == "a2dp-sink" ]]; then
    echo "🔵🎵 High Quality ($BATTERY_ICON)"
else
    echo "🔵🎤 Mic Enabled ($BATTERY_ICON)"
fi

# Handle click events to toggle profile
if [[ "$1" == "toggle" ]]; then
    if [[ "$CURRENT_PROFILE" == "a2dp-sink" ]]; then
        pactl set-card-profile $DEVICE headset-head-unit-msbc
    else
        pactl set-card-profile $DEVICE a2dp-sink
    fi
fi
