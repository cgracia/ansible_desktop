#!/bin/sh -e

# Stop playing music
# cmus-remote --stop || true

# Take a screenshot
#xset dpms force on
#scrot /tmp/screen_locked.png

# Pixellate it 10x
#mogrify -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock screen displaying this image.
# i3lock -i /tmp/screen_locked.png
i3lock-fancy &

# Turn the screen off after a delay.
sleep 20; pgrep i3lock && xset dpms force off
