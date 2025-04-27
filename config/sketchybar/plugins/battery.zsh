#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.sh"

BATTERY=$(pmset -g batt)

if [[ -z "$BATTERY" || "$BATTERY" == *charged* || "$BATTERY" == *"finishing charge"* ]]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

sketchybar --set "$NAME" drawing=on

CHARGING="$([[ "$BATTERY" == *discharging* ]] || printf '⚡ ')"

[[ "$NAME" = *-hover ]] \
    && LABEL="$CHARGING$(grep -o '\d\+%' <<< $BATTERY)" \
    || LABEL="$CHARGING$(grep -o '\d\+:\d\+' <<< $BATTERY || echo '···')"

sketchybar --set "$NAME" label="$LABEL"
