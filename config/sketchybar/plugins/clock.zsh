#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.zsh"

# | xargs trims whitespace
$HOVERING \
    && label=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || label=$(date +%l:%M | xargs)

sketchybar --set "$NAME" label="$label"
