#!/bin/sh

NAME_ORIG="$(echo "$NAME" | sed 's/-hover$//')"
NAME_NEW="$NAME"

case "$SENDER" in
  "mouse.entered") NAME_NEW="$NAME_ORIG-hover";;
  "mouse.exited") NAME_NEW="$NAME_ORIG";;
esac
[[ "$NAME" != "$NAME_NEW" ]] && sketchybar --rename "$NAME" "$NAME_NEW"

# | xargs trims whitespace
[[ "$NAME_NEW" = *-hover ]] \
    && label=$(date +%m/%d | xargs | tr -d '\n'; printf "  "; date +%l:%M:%S | xargs) \
    || label=$(date +%l:%M | xargs)

sketchybar --set "$NAME_NEW" label="$label"
