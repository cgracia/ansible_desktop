#!/bin/bash

url=$(xclip -o)
notify-send "Downloading $url"
dest=~/Music

result=$(youtube-dl --format m4a --add-metadata --output $dest'/%(title)s.%(ext)s' $url)

notify-send "Youtube downloader finished with result $result"
