#!/bin/bash

# Get cmus status
status=$(cmus-remote -Q 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "No music playing"
    sleep 10  # Slow update when cmus is not running
    exit
fi

# Extract playing status, artist, title, and position info
state=$(echo "$status" | grep 'status' | awk '{print $2}')
title=$(echo "$status" | grep 'tag title' | cut -d ' ' -f 3-)
artist=$(echo "$status" | grep 'tag artist' | cut -d ' ' -f 3-)
current_time=$(echo "$status" | grep 'position' | awk '{print $2}')
duration=$(echo "$status" | grep 'duration' | awk '{print $2}')

# Ensure current_time and duration are valid integers
if [[ -z "$current_time" || -z "$duration" || ! "$current_time" =~ ^[0-9]+$ || ! "$duration" =~ ^[0-9]+$ ]]; then
    current_time=0
    duration=0
fi

# Format current time and duration as MM:SS
format_time() {
    local time=$1
    minutes=$((time / 60))
    seconds=$((time % 60))
    printf "%02d:%02d" $minutes $seconds
}

formatted_current_time=$(format_time $current_time)
formatted_duration=$(format_time $duration)

# Determine the icon based on playback state
if [ "$state" == "playing" ]; then
    icon="%{T3}\uF04B%{T-}"
    # Update frequently when playing
elif [ "$state" == "paused" ]; then
    icon="%{T3}\uF04C%{T-}"
    sleep 5  # Slower updates when paused
else
    icon="%{T3}\uF04D%{T-}"
    sleep 10  # Slow update when stopped
fi

# Output to Polybar
echo -e "$icon $artist - $title [$formatted_current_time/$formatted_duration]"
