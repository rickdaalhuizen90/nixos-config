#!/usr/bin/env bash

if [ -n "$1" ]; then
    brightnessctl set "$1" > /dev/null
fi

BRIGHTNESS=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')

ID=9994

notify-send -a "System" -r "$ID" -u low "Brightness: ${BRIGHTNESS}%" \
    -h int:value:"$BRIGHTNESS" \
    -h string:x-canonical-private-synchronous:brightness \
    -i display-brightness-symbolic -t 2000
