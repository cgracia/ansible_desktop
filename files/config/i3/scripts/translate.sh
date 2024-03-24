#!/bin/bash

input=$(xclip -o)
notify-send "Translating $input"

result=$(curl https://api-free.deepl.com/v2/translate \
-d auth_key=9806bad0-7b1a-7611-e5be-6eb3f5bfc4f4:fx \
-d "text=$input" \
-d "target_lang=EN-US")

language=$(echo $result | jq '.translations[0].detected_source_language')
notify-send "Detected language: $language"
text=$(echo $result | jq '.translations[0].text')
echo $text
notify-send "$text"
