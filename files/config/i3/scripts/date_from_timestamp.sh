#!/bin/bash

datetime=$(xclip -o)

if ! [[ $datetime =~ ^[0-9]+([.][0-9]+)?$ ]] ; then
    notify-send "Not a valid number"
else
    current_timestamp=$(date +%s)

    # If the time is in milliseconds, convert it to seconds
    if (( datetime > current_timestamp + 1000000000 )); then
        datetime=$(echo "$datetime / 1000" | bc -l)
    fi

    notify-send "$(date --date=@$datetime)"
fi
