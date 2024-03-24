#!/bin/bash

FILE=/tmp/pomodoro-status
HISTORY=/var/tmp/pomodoro-history
DURATION=1500

start_pomodoro () {
    start_time=$(date +%s)
    end_time=$(($start_time + $DURATION))
    echo "$start_time,$end_time" >> $FILE
    pkill -RTMIN+12 i3blocks
    sleep 5 && notify-send "DUNST_COMMAND_PAUSE"
}

stop_pomodoro () {
    interrupted=$1
    status=$(cat $FILE)
    now=$(date +%s)
    echo "$status,$now,$interrupted" >> $HISTORY
    rm $FILE
    pkill -RTMIN+12 i3blocks
    notify-send "DUNST_COMMAND_RESUME"
}

update_pomodoro () {
    now=$(date +%s)
    end_time=$(head -n 2 $FILE | tail -n 1)
    if [[ $now -gt $end_time ]]; then
        notify-send "Break"
        stop_pomodoro 0
        pkill -RTMIN+12 i3blocks
    fi
}

while getopts ":su" opt; do
    case $opt in
        s)
            if [ -f "$FILE" ]; then
                notify-send "Stopping pomodoro"
                stop_pomodoro 1
            else
                notify-send "Starting pomodoro"
                start_pomodoro
            fi
            ;;
        u)
            if [ -f "$FILE" ]; then
                update_pomodoro
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
