#!/bin/zsh

case "$SENDER" in
    front_app_switched)
        front_app="$([[ "$INFO" == "Finder" ]] && echo "" || echo "$INFO")"
        if sketchybar --query "APP-$front_app-1" &>/dev/null; then
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
