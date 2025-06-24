NAME_ORIG="$(echo "$NAME" | sed 's/_HOVER_//')"
NAME_NEW="$NAME"

case "$SENDER" in
  "mouse.entered") NAME_NEW="${NAME_ORIG}_HOVER_";;
  "mouse.exited") NAME_NEW="$NAME_ORIG";;
esac
[[ "$NAME" != "$NAME_NEW" ]] && sketchybar --rename "$NAME" "$NAME_NEW"

NAME="$NAME_NEW"

[[ "$NAME" = *_HOVER_* ]] \
    && HOVERING=true \
    || HOVERING=false
