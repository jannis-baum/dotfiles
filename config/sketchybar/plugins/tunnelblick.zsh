#!/bin/zsh

if [[ $(ps aux | grep openvpn | wc -l ) -gt 1 ]]; then
    drawing=on
    label="􀤆"
else
    drawing=off
    label=""
fi

sketchybar --set "$NAME" label="$label" drawing=$drawing
