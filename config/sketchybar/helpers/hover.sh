#!/bin/sh

NAME_ORIG="$(echo "$NAME" | sed 's/-hover$//')"
NAME_NEW="$NAME"

case "$SENDER" in
  "mouse.entered") NAME_NEW="$NAME_ORIG-hover";;
  "mouse.exited") NAME_NEW="$NAME_ORIG";;
esac
[[ "$NAME" != "$NAME_NEW" ]] && sketchybar --rename "$NAME" "$NAME_NEW"

NAME="$NAME_NEW"
