#!/bin/sh -e
# Stop playing music if cmus is running
if cmus-remote -Q > /dev/null 2>&1; then
    cmus-remote --pause-playback
    echo "Music paused in cmus."
else
    echo "cmus is not running. Skipping music pause."
fi

i3lock-fancy &

# Brief delay to ensure i3lock starts
sleep 10

delay=20
log_file="/tmp/fuzzy_lock.log"
lock_start=$(date +%s)  # Record the lock start time
sleep_threshold=3600   # 60 minutes in seconds

echo "$(date): Lock initiated" >> "$log_file"

while true; do
    # Check if i3lock is running
    if pgrep i3lock > /dev/null; then
        current_time=$(date +%s)
        elapsed=$(( current_time - lock_start ))

        # If 30 minutes have elapsed, suspend or hibernate the system
        if [ "$elapsed" -ge "$sleep_threshold" ]; then
            echo "$(date): 30 minutes elapsed, suspending system." >> "$log_file"
            systemctl suspend-then-hibernate
            break
        fi

        echo "$(date): i3lock is running, waiting for $delay seconds." >> "$log_file"
        sleep $delay

        # Check again to make sure the system didn't get unlocked while waiting
        if pgrep i3lock > /dev/null; then
            echo "$(date): Attempting to turn off the screen." >> "$log_file"
            xset dpms force off
        fi
    else
        # If i3lock is not running, exit the loop
        echo "$(date): i3lock is not running. Exiting." >> "$log_file"
        break
    fi
done
