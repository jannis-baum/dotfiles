#!/bin/zsh

if [[ "$SENDER" = "volume_change" ]]; then
    case "$INFO" in
      [6-9][0-9]|100) label="􀊨"
      ;;
      [3-5][0-9]) label="􀊦"
      ;;
      [1-9]|[1-2][0-9]) label="􀊤"
      ;;
      *) label=""
    esac

    sketchybar --set "$NAME" label="$label"
fi
