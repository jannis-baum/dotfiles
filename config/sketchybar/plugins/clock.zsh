#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.zsh"

# | xargs trims whitespace
$HOVERING \
    && LABEL=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || LABEL=$(date +%l:%M | xargs)

sketchybar --set "$NAME" label="$LABEL"
