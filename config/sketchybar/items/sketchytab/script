#!/bin/zsh

[[ "$SENDER" == "front_app_switched" ]] || exit 0

DRAW=$([[ "$NAME" = *"$INFO"* ]] && printf "on" || printf "off")
sketchybar --set "$NAME" drawing="$DRAW"
