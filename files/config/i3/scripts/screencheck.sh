#!/bin/bash

logger "ACPI event: $*"

#EDID_MONITOR1="00ffffffffffff0010ac98a14c384a311a200104b53c22783b5095a8544ea5260f5054a54b00714f8180a9c0a940d1c0e100010101014dd000a0f0703e803020350055502100001a000000ff004350394a4d34330a2020202020000000fc0044454c4c20533237323151530a000000fd00283c89893c010a20202020202001af020321f15461010203040506071011121415161f20215d5e5f2309070783010000565e00a0a0a029503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc"
#EDID_MONITOR2="00ffffffffffff001e6d0677c36c0100041f0103803c2278ea3e31ae5047ac270c50542108007140818081c0a9c0d1c081000101010108e80030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00383d1e873c000a202020202020000000fc004c472048445220344b0a20202001ab020338714d9022201f1203040161605d5e5f230907076d030c001000b83c20006001020367d85dc401788003e30f0003e305c000e3060501023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a000000ff003130344e544d5832523337390a0000000000000000000000000000000000d4"
#
#get_monitor_by_edid() {
#    local edid=$1
#    local monitor=""
#    local current_edid=""
#    local collecting_edid=false
#
#    while IFS= read -r line; do
#        if [[ $line =~ ^[[:space:]]*EDID ]]; then
#            collecting_edid=true
#            current_edid=""
#        elif $collecting_edid && [[ $line =~ ^[[:space:]] ]]; then
#            current_edid+=$(echo "$line" | sed 's/^[[:space:]]*//g')
#        elif $collecting_edid; then
#            collecting_edid=false
#            current_edid=$(echo $current_edid | cut -d' ' -f1)  # Extract only the hexadecimal part
#            echo "DEBUG: Monitor: $monitor, EDID: $current_edid"
#            if [[ $current_edid == $edid ]]; then
#                echo "Match found for $monitor"
#                echo "$monitor"
#                return
#            fi
#        elif [[ $line =~ connected ]]; then
#            monitor=$(echo "$line" | cut -d' ' -f1)
#        fi
#    done < <(xrandr --props)
#}
#
#MONITOR1=$(get_monitor_by_edid "$EDID_MONITOR1")
#MONITOR2=$(get_monitor_by_edid "$EDID_MONITOR2")
#
#echo $MONITOR1
#echo $MONITOR2
#
#if [ -n "$MONITOR1" ] && [ -n "$MONITOR2" ]; then
#    notify-send "$MONITOR1 and $MONITOR2 found"
#    xrandr --output eDP-1 --mode 1920x1200 --pos 0x2029 --rotate normal --output $MONITOR1 --mode 3840x2160 --pos 5760x0 --rotate right --output $MONITOR2 --primary --mode 3840x2160 --pos 1920x668 --rotate normal
#elif [ -n "$MONITOR1" ]; then
#    notify-send "$MONITOR1 found"
#    xrandr --output "$MONITOR1" --auto
#elif [ -n "$MONITOR2" ]; then
#    notify-send "$MONITOR2 found"
#    xrandr --output "$MONITOR2" --auto
#else
#    notify-send "No external monitor"
#    xrandr --output "DP-2" --off
#    xrandr --output "DP-3" --off
#fi

monitor="eDP-1"
monitor2="HDMI-2"
monitor3="DP-2"
monitor4="DP-1"
monitor5="DP-2-2"
monitor6="DP-1-2"

xrandr --output "$monitor" --auto

if xrandr | grep -q "$monitor2 connected"; then
    notify-send "Home monitor found"
	xrandr --output "$monitor2" --auto
	xrandr --output "$monitor2" --right "$monitor"
elif xrandr | grep -q "^$monitor5 connected"; then
    notify-send "HUB31 monitor found - $monitor5"
    xrandr --output DP-3 --off --output $monitor4 --mode 3840x2160 --pos 5760x0 --rotate right --output $monitor --primary --mode 1920x1200 --pos 3840x1992 --rotate normal --output $monitor5 --mode 3840x2160 --pos 0x1032 --rotate normal
elif xrandr | grep -q "^$monitor3 connected"; then
    notify-send "HUB31 monitor found"
    xrandr --output DP-3 --off --output DP-1 --mode 3840x2160 --pos 5760x0 --rotate right --output eDP-1 --primary --mode 1920x1200 --pos 3840x1992 --rotate normal --output DP-2 --mode 3840x2160 --pos 0x1032 --rotate normal
elif xrandr | grep -q "^$monitor4 connected"; then
    notify-send "HUB31 monitor found"
    xrandr --output DP-3 --off --output $monitor4 --mode 3840x2160 --pos 5760x0 --rotate right --output $monitor --primary --mode 1920x1200 --pos 3840x1992 --rotate normal --output $monitor5 --mode 3840x2160 --pos 0x1032 --rotate normal
elif xrandr | grep -q "^$monitor6 connected"; then
    xrandr --output eDP-1 --mode 1920x1200 --pos 0x2029 --rotate normal --output DP-1 --off --output DP-2 --mode 3840x2160 --pos 5760x0 --rotate right --output DP-3 --off --output DP-1-1 --off --output DP-1-2 --primary --mode 3840x2160 --pos 1920x668 --rotate normal --output DP-1-3 --off
else
    notify-send "No external monitor"
	xrandr --output "$monitor2" --off
	xrandr --output "$monitor3" --off
	xrandr --output "$monitor4" --off
	xrandr --output "$monitor5" --off
	xrandr --output "$monitor6" --off
fi
