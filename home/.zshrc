export ZSH="${HOME}/.oh-my-zsh"
export PATH="${PATH}:${HOME}/data/_resources/bin:${HOME}/.flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin/"


# theme: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="minimal"


# generic aliases
alias ej="eject /Volumes/LaCie"
alias karabiner-cli="/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"


# generic functions
## make and change to directory
function mcd() {
    test -d "$1" || mkdir "$1" && cd "$1"
}
## list newest (date changed) files
function lsn() {
	ls -t $2 | head -$1
}
## lsn-do NEWEST_N PATH COMMAND
function lsnp() {
    ls -t $2 | head -$1 | sed 's,^,'$2'\/,'
    # | sed 's/$/"/'
}
## generate new password
function pass-n() {
	echo | pbcopy
	while [[ $(pbpaste) =~ '^[^0-9]*$' || $(pbpaste) =~ '^[^a-z]*$' || $(pbpaste) =~ '^[^A-Z]*$' ]]; do
        cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9-_\$,.!?/' | fold -w 32 | sed 1q | tr -d '\n' | pbcopy
	done
}
## quick look
function ql() {
    qlmanage -p "$1" >& /dev/null
}


# linking scripts
alias mue="~/data/_resources/markup-export/main.py"
alias cookie-cleaner="~/data/_resources/cookie-cleaner/.build/release/cookie-cleaner ~/data/_resources/cookie-cleaner/whitelist.txt"
alias desknotes="~/data/_resources/desktop-notes/desknotes.py"
alias pass="/Users/jannisbaum/data/_resources/keychains/main.py"
function fbm() {
    ~/data/_resources/file-bookmarks/fbm.py $@
}


# git
alias gs="git status -s"
function ga() {
    git add $* && git status -s
}
function gr() {
    git restore --staged $* && git status -s
}
function gc() {
    git commit -m "$*"
}


# zsh
source $ZSH/oh-my-zsh.sh
bindkey -v

