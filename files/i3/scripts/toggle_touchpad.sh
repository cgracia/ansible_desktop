#!/bin/bash

declare -i ID
ID=12
declare -i STATE
STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
if [ $STATE -eq 1 ]
then
    xinput disable $ID
    echo "Touchpad disabled."
    xdotool mousemove 0 1080
else
    xinput enable $ID
    echo "Touchpad enabled."
fi
