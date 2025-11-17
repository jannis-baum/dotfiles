#!/bin/zsh

kitty_sockets=(/tmp/kitty-*(=N))
socket="$kitty_sockets[1]"
[[ -n "$socket" ]] || return

/opt/homebrew/bin/kitten @ --to unix:"$socket" launch \
    --no-response \
    --type=tab \
    $HOME/.local/bin/viclip
open -a kitty
