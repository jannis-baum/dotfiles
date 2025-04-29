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
        if [[ "$line" = FAINT* ]]; then
            label_font='Menlo:Normal:14'
            label_color='0xff808080'
        else
            label_font='Menlo:Bold:14'
            label_color='0xffbbbbbb'
        fi

        sketchybar \
            --add item "$item_name" left \
            --set "$item_name" \
                script="~/.config/sketchybar/plugins/app.zsh" \
                drawing="$should_draw" \
                label="$label" \
                label.font="$label_font" \
                label.color="$label_color" \
            --subscribe "$item_name" front_app_switched
        ((line_num++))
    done
}

# non-blocking for kitty
set-app-items &
