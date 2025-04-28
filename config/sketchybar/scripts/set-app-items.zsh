#!/bin/zsh

if [[ $# != 1 ]]; then
    echo "usage: $0 <app-name>" >&2
    exit 1
fi
app_name="$1"

function set-app-items() {
    sketchybar --remove '/APP-'"$app_name"'-\d*/' &>/dev/null

    frontmost_app="$(osascript -l JavaScript -e 'ObjC.import("AppKit");$.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName')"
    should_draw="$([[ "$frontmost_app" == "$app_name" ]] && printf "on" || printf "off")"

    line_num=1
    while IFS= read -r line; do
        item_name="APP-$app_name-$line_num"
        label="$(sed 's/^FAINT //' <<<"$line")"

        sketchybar \
            --add item "$item_name" left \
            --set "$item_name" \
                script="~/.config/sketchybar/plugins/app.zsh" \
                label="$label" \
                drawing="$should_draw" \
                label.color="$([[ "$line" = FAINT* ]] && printf "0xff808080" || printf "0xffbbbbbb")" \
                background.border_color="$([[ "$line" = FAINT* ]] && printf "0xff202020" || printf "0xff404040")" \
            --subscribe "$item_name" front_app_switched
        ((line_num++))
    done
}

# non-blocking for kitty
set-app-items &
