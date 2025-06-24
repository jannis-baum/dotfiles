#!/bin/zsh

source "$CONFIG_DIR/helpers/fullscreen.zsh"

[[ "$SENDER" == "front_app_switched" ]] || exit 0

! $FULLSCREEN && [[ "$NAME" = *"APP-$INFO"* ]] \
    && drawing=on \
    || drawing=off

sketchybar --set "$NAME" drawing="$drawing"
