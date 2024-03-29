#!/bin/zsh

battery=$(pmset -g batt)

[[ -z "$battery" || "$battery" == *charged* ]] && exit 0
[[ "$battery" == *discharging* ]] || printf '⚡ '

if [[ "$1" == "--percentage" || "$1" == "-p" ]]; then
    grep -o '\d\+%' <<< $battery
else
    grep -o '\d\+:\d\+' <<< $battery || echo '⋯'
fi
