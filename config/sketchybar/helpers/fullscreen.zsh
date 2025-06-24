NAME_ORIG="$(echo "$NAME" | sed 's/_FULLSCREEN_//')"
NAME_NEW="$NAME"

if [[ "$SENDER" == "space_change" ]]; then
    space="$(jq -r '."display-1"' <<< "$INFO")"
    [[ "$space" -gt 1 ]] \
        && NAME_NEW="${NAME_ORIG}_FULLSCREEN_" \
        || NAME_NEW="$NAME_ORIG"
fi
[[ "$NAME" != "$NAME_NEW" ]] && sketchybar --rename "$NAME" "$NAME_NEW"

[[ "$NAME" = *_FULLSCREEN_* ]] \
    && FULLSCREEN=true \
    || FULLSCREEN=false
