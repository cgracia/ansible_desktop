#!/bin/bash

url=$(xclip -o)
notify-send "Downloading $url"
dest=~/Music

result=$(yt-dlp -x --audio-format opus --add-metadata --output "$dest/%(uploader)s/%(title)s.%(ext)s" "$url")

notify-send "Youtube downloader finished with result $result"
