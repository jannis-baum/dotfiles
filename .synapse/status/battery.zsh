#!/bin/zsh

BATTERY=$(pmset -g batt)

[[ -z "$BATTERY" || "$BATTERY" == *charged* ]] && exit 0
[[ "$BATTERY" == *discharging* ]] || printf '⚡ '

if [[ "$1" == "--percentage" || "$1" == "-p" ]]; then
    echo "$BATTERY" | grep -o '\d\+%'
else
    echo "$BATTERY" | grep -o '\d\+:\d\+' || echo '⋯'
fi
