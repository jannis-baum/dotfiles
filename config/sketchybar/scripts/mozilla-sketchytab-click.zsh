#!/bin/zsh

[[ -n "$TAB_ID" ]] || exit

[[ "$BUTTON" = left ]] && action="switchto"
[[ "$BUTTON" = right ]] && action="close"

curl "http://localhost:11912/?$action=$TAB_ID"
