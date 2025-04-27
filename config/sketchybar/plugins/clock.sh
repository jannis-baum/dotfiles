#!/bin/sh

source "$CONFIG_DIR/helpers/hover.sh"

# | xargs trims whitespace
[[ "$NAME" = *-hover ]] \
    && label=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || label=$(date +%l:%M | xargs)

sketchybar --set "$NAME" label="$label"
