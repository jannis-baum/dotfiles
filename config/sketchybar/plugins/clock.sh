#!/bin/sh

source "$CONFIG_DIR/helpers/hover.sh"

# | xargs trims whitespace
[[ "$NAME" = *-hover ]] \
    && LABEL=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || LABEL=$(date +%l:%M | xargs)

sketchybar --set "$NAME" label="$LABEL"
