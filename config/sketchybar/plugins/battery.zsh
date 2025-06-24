#!/bin/zsh

source "$CONFIG_DIR/helpers/hover.zsh"

batt_output=$(pmset -g batt)

if [[ -z "$batt_output" || "$batt_output" == *charged* || "$batt_output" == *"finishing charge"* ]]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

sketchybar --set "$NAME" drawing=on

charging="$([[ "$batt_output" == *discharging* ]] || printf '⚡ ')"
percentage="$(grep -o '\d\+%' <<< "$batt_output" | tr -d '%')"
time="$(grep -o '\d\+:\d\+' <<< $batt_output || echo '···')"

[[ "$percentage" -gt 10 ]] \
    && color=0xffbbbbbb \
    || color=0xfffc897e

[[ "$NAME" = *-hover ]] \
    && LABEL="$charging$percentage%" \
    || LABEL="$charging$(grep -o '\d\+:\d\+' <<< $batt_output || echo '···')"

sketchybar --set "$NAME" \
    label="$LABEL" \
    label.color="$color"
