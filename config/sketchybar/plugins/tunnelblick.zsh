#!/bin/zsh
#

if [[ $(ps aux | grep openvpn | wc -l ) -gt 1 ]]; then
    label="􀤆"
else
    label=""
fi

sketchybar --set "$NAME" label="$label"
