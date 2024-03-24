#!/bin/bash

# Define the numid for the USB microphone 'Mic Capture Switch'
usb_mic_numid=7
# Assuming that the internal mic is on card 0, and using 'Capture' as the control name
internal_mic_control="Capture"
internal_mic_card=0

# Get the current state of the USB microphone
usb_mic_state=$(amixer -c 1 cget numid=$usb_mic_numid | grep -oE 'values=on|values=off')

# Get the current state of the internal microphone
internal_mic_state=$(amixer -c $internal_mic_card get $internal_mic_control | grep -oE '\[on\]|\[off\]')

# If either of the microphones is currently unmuted, mute both.
if [[ "$usb_mic_state" == 'values=on' ]] || [[ "$internal_mic_state" == '[on]' ]]; then
    # Mute USB microphone
    amixer -c 1 cset numid=$usb_mic_numid off
    # Mute internal microphone
    amixer -c $internal_mic_card set $internal_mic_control nocap
    echo "Both microphones muted."
else
    # Unmute USB microphone
    amixer -c 1 cset numid=$usb_mic_numid on
    # Unmute internal microphone
    amixer -c $internal_mic_card set $internal_mic_control cap
    echo "Both microphones unmuted."
fi
