#!/bin/bash

monitor="eDP-1"
monitor2="HDMI-2"
monitor3="DP-1-1"
monitor4="DP-1-3"

if xrandr | grep "$monitor2 connected"; then
    i3-msg move $1 to output right
elif xrandr | grep "^$monitor4 connected"; then
    i3-msg move $1 to output right
else
    notify-send "No external monitor"
fi
