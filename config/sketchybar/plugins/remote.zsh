#!/bin/zsh

source ~/.config/zsh/scripts/remote.zsh

_rem_is_connected
case "$?" in
    0) drawing=on; label="􀤆";;
    1) drawing=off; label="";;
    *) drawing=on; label="􃑺";;
esac

sketchybar --set "$NAME" label="$label" drawing=$drawing
