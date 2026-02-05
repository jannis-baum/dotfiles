#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.zsh"

$HOVERING \
    && draw_popup=on \
    || draw_popup=off

sketchybar --set "$NAME" label="$(date +%l:%M | xargs)" popup.drawing=$draw_popup
