#!/usr/bin/env bash

if [ "$1" == "toggle" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
else
    if [ -n "$1" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ "$1"
        pactl set-sink-mute @DEFAULT_SINK@ 0
    fi
fi

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F/ '/Volume:/ {print $2}' | tr -d ' %' | xargs)
IS_MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

ID=9993

if [ "$IS_MUTED" = "yes" ]; then
    notify-send -a "System" -r "$ID" -u low "Muted" -i audio-volume-muted-symbolic -t 2000
else
    notify-send -a "System" -r "$ID" -u low "Volume: ${VOLUME}%" \
    -h int:value:"$VOLUME" -h string:x-canonical-private-synchronous:volume \
    -i audio-volume-high-symbolic -t 2000
fi
