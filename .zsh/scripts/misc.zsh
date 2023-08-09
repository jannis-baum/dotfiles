# generic aliases
alias c="printf '\n%.0s' {2..$LINES} && clear"
alias ej="diskutil eject /Volumes/LaCie*"
alias convert-file="ffmpeg"
alias w='printf "%s" "$(vipe)" | pbcopy'
alias ssh='kitty +kitten ssh'
alias trm='trash -F'

# linking scripts
alias mue="~/.lib/markup-export/main"

# functions
## generate new password
function passn() {
	echo | pbcopy
	while [[ $(pbpaste) =~ '^[^0-9]*$' || $(pbpaste) =~ '^[^a-z]*$' || $(pbpaste) =~ '^[^A-Z]*$' ]]; do
        cat /dev/urandom \
            | LC_ALL=C tr -dc 'a-zA-Z0-9-_\$,.!?:;~`^+=@&%#*[](){}/' \
            | fold -w 32 \
            | head -1 \
            | tr -d '\n' \
            | pbcopy
	done
}
## quick look
function ql() {
    if test -e "$1"; then
        qlmanage -p "$1" >& /dev/null
    else
        echo "\"$1\": No such file or directory"
    fi
}
## pip installed version for requirements.txt
function pipf() {
    pip3 freeze | rg "$1" | sed 's/==/>=/' | pbcopy
}
## reload color schemes
function rcols() {
    make -C ~/_dotfiles/.lib/nosync/color-schemes
    [[ -n "$KITTY_PID" ]] && kill -SIGUSR1 $KITTY_PID
    _si_vim_isrunning && _si_vim_cmd ReloadConfig
}

# options
setopt no_beep
## history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
