#!/bin/bash

# Get default sink and source
default_sink=$(pactl get-default-sink)
default_source=$(pactl get-default-source)

# Get mute status
sink_mute=$(pactl get-sink-mute "$default_sink" | grep -oP '(?<=Mute: ).*')
source_mute=$(pactl get-source-mute "$default_source" | grep -oP '(?<=Mute: ).*')

# Get volume levels
sink_volume=$(pactl get-sink-volume "$default_sink" | awk '{print $5}')
source_volume=$(pactl get-source-volume "$default_source" | awk '{print $5}')

# Output formatted status
echo "Output: $sink_volume $( [ "$sink_mute" = "yes" ] && echo '[Muted]' ) | Input: $source_volume $( [ "$source_mute" = "yes" ] && echo '[Muted]' )"
