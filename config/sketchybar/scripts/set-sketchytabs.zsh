#!/bin/zsh

if [[ $# != 1 ]]; then
    echo "usage: $0 <app-name>" >&2
    exit 1
fi
app_name="$1"

function set-sketchytabs() {
    # collect args & only call sketchybar once to speed up execution
    sketchy_args=(--remove '/APP-'"$app_name"'-\d*/')

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

        sketchy_args+=(
            --add item "$item_name" left
            --set "$item_name"
                script="~/.config/sketchybar/plugins/sketchytab.zsh"
                drawing="$should_draw"
                label="$label"
                label.font="$label_font"
                label.color="$label_color"
            --subscribe "$item_name" front_app_switched
        )

        matching_images=(/Volumes/sketchytabs/$app_name/$line_num.*(.N))
        image="$matching_images[1]"
        if [[ -n "$image" ]]; then
            sketchy_args+=(--set "$item_name"
                background.drawing=on background.image.drawing=on
                icon.padding_left=8
                background.padding_left=8
                background.image.string="$image"
                background.image.scale=0.5
            )
        fi
        ((line_num++))
    done
    sketchybar "${sketchy_args[@]}" &>/dev/null
}

# non-blocking for kitty
set-sketchytabs &
