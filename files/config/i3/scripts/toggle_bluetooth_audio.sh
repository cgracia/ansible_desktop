#!/bin/bash

DEVICE="bluez_card.80_C3_BA_50_05_60"

# Get the current active profile
CURRENT_PROFILE=$(pactl list cards | grep -A 20 $DEVICE | grep "Active Profile" | awk '{print $3}')

if [[ "$CURRENT_PROFILE" == "a2dp-sink" ]]; then
    # Switch to HSP/HFP with mSBC for mic
    pactl set-card-profile $DEVICE headset-head-unit-msbc
    notify-send "Switched to HSP/HFP (mic enabled)"
else
    # Switch to A2DP for high-quality audio
    pactl set-card-profile $DEVICE a2dp-sink
    notify-send "Switched to A2DP (high-quality audio)"
fi
