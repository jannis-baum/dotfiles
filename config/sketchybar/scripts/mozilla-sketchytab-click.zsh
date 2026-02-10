#!/bin/zsh

[[ -n "$TAB_ID" ]] || exit

curl "http://localhost:11912/?tab=$TAB_ID"
