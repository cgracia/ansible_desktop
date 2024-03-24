#!/bin/bash

# Define the numid for the USB microphone 'Mic Capture Switch'
usb_mic_numid=7
# Assuming that the internal mic is on card 0
internal_mic_card=0

# Get the status of the USB microphone
usb_mic_status=$(amixer -c 1 cget numid=$usb_mic_numid | grep -oE 'values=on|values=off')

# Get the status of the internal microphone
# Parsing for 'Front Left' or 'Front Right' line mute status
internal_mic_status=$(amixer -c $internal_mic_card get Capture | grep -Eo '\[on\]|\[off\]' | head -1)

# Parse and output the USB microphone status
echo -n "USB Microphone: "
if [[ "$usb_mic_status" == 'values=on' ]]; then
    echo "Unmuted"
else
    echo "Muted"
fi

# Parse and output the internal microphone status
echo -n "Internal Microphone: "
if [[ "$internal_mic_status" == '[on]' ]]; then
    echo "Unmuted"
else
    echo "Muted"
fi
