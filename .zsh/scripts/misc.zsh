# generic aliases
alias c="printf '\n%.0s' {2..$LINES} && clear"
alias ej="eject /Volumes/LaCie*"
alias convert-file="ffmpeg"
alias w='printf "%s" "$(vipe)" | pbcopy'
alias ssh='kitty +kitten ssh'
alias trm='trash -F'

# linking scripts
alias mue="~/_lib/markup-export/main"
alias cookie-cleaner="~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/.safari/cookie-whitelist.txt"
alias desknotes="~/_lib/desktop-notes/desknotes"
alias pass="~/_lib/keychains/main"
alias fbm="~/_lib/file-bookmarks/file-bookmarks"

# generic functions
## make dirs to open editor
## open in running vim if suspended
function v() {
    mkdir -p $(dirname $1)

    local vim_id=$(jobs | sed -E -n 's/\[([0-9])\][ +-]* [a-zA-Z]*[[:space:]]*v .*/\1/p' | head -1)
    if [[ -n "$vim_id" ]]; then
        echo "tabedit $1" > $HOME/.vim/resume-source.vim
        fg %$vim_id
    else
        vim $1
    fi
}
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

# options
setopt no_beep
## history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
