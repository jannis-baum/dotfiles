#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.zsh"
source "$CONFIG_DIR/helpers/fullscreen.zsh"

# | xargs trims whitespace
$HOVERING \
    && label=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || label=$(date +%l:%M | xargs)

$FULLSCREEN \
    && drawing="off" \
    || drawing="on"

sketchybar --set "$NAME" label="$label" drawing="$drawing"
