name_orig="$(echo "$NAME" | sed 's/_HOVER_//')"
name_new="$NAME"

case "$SENDER" in
  "mouse.entered") name_new="${name_orig}_HOVER_";;
  "mouse.exited") name_new="$name_orig";;
esac
[[ "$NAME" != "$name_new" ]] && sketchybar --rename "$NAME" "$name_new"

NAME="$name_new"

[[ "$NAME" = *_HOVER_* ]] \
    && HOVERING=true \
    || HOVERING=false
