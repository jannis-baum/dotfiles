#!/bin/zsh

batt_output="$(pmset -g batt)"
percentage="$(grep -o '\d\+%' <<<"$batt_output" | tr -d '%')"

icon="􀛪"
[[ "$percentage" -ge 25 ]] && icon="􀛩"
[[ "$percentage" -ge 50 ]] && icon="􀺶"
[[ "$percentage" -ge 75 ]] && icon="􀺸"
[[ "$percentage" -ge 100 ]] && icon="􀛨"
[[ "$batt_output" == *discharging* ]] || icon="􀢋"

sketchybar --set "$NAME" label="$icon $percentage%"
