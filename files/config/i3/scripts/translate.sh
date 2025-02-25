#!/bin/bash

source ~/.secrets/deepl.env

input=$(xclip -o)
notify-send "Translating $input"

result=$(curl https://api-free.deepl.com/v2/translate \
-d "auth_key=$DEEPL_API_KEY" \
-d "text=$input" \
-d "target_lang=EN-US")

echo $result
notify-send $result
language=$(echo $result | jq '.translations[0].detected_source_language')
notify-send "Detected language: $language"
text=$(echo $result | jq '.translations[0].text')
echo $text
notify-send "$text"
