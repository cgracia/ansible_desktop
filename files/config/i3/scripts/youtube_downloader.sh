#!/bin/bash

url=$(xclip -o)
notify-send "Downloading $url"
dest=~/Music

result=$(yt-dlp -x --audio-format opus --add-metadata --output "$dest/%(uploader)s/%(title)s.%(ext)s" "$url")

if [ $? -eq 0 ]; then
    cmus-remote -C "add $dest"
fi

notify-send "Youtube downloader finished with result $result"
