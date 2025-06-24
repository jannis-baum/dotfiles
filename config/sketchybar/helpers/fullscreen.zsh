name_orig="$(echo "$NAME" | sed 's/_FULLSCREEN_//')"
name_new="$NAME"

if [[ "$SENDER" == "space_change" ]]; then
    space="$(jq -r '."display-1"' <<< "$INFO")"
    [[ "$space" -gt 1 ]] \
        && name_new="${name_orig}_FULLSCREEN_" \
        || name_new="$name_orig"
fi
[[ "$NAME" != "$name_new" ]] && sketchybar --rename "$NAME" "$name_new"

[[ "$NAME" = *_FULLSCREEN_* ]] \
    && FULLSCREEN=true \
    || FULLSCREEN=false
