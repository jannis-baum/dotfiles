#!/bin/sh

# | xargs to trim whitespace
sketchybar --set "$NAME" label="$(date +%l:%M | xargs)"
