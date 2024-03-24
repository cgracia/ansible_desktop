#!/bin/bash

datetime=$(xclip -o)

if ! [[ $datetime =~ ^[0-9]+([.][0-9]+)?$ ]] ; then
    notify-send "Not a valid number"
else
    notify-send "$(date --date=@$datetime)"
fi
