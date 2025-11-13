#!/bin/zsh

case "$SENDER" in
    front_app_switched)
        case "$INFO" in
            Finder)
                front_app="";;
            sioyek)
                front_app="$(~/.local/bin/masi --get | cut -d' ' -f1)";;
            *)
                front_app="$INFO";;
        esac
        if sketchybar --query "APP-$INFO-1" &>/dev/null; then
            sketchybar --set "$NAME" drawing=off
        else
            sketchybar --set "$NAME" drawing=on label="$front_app"
        fi
        ;;
    tabs_updated)
        current_app="$(osascript -l JavaScript -e 'ObjC.import("AppKit");$.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName')"
        if [[ "$current_app" = "$TAB_APP" ]]; then
            draw=$([[ "$N_TABS" = 0 ]] && echo "on" || echo "off")
            sketchybar --set "$NAME" drawing=$draw
        fi
        ;;
esac
