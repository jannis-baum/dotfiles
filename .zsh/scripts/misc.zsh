# generic aliases
alias sdf="sync-dotfiles"
alias cl="clear"
alias kl="cookie-cleaner && quit-apps"
alias ej="eject /Volumes/LaCie"
alias karabiner-cli="/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
alias convert-file="ffmpeg"

# linking scripts
alias mue="~/_lib/markup-export/main"
alias cookie-cleaner="~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt"
alias desknotes="~/_lib/desktop-notes/desknotes"
alias pass="~/_lib/keychains/main"
alias fbm="~/_lib/file-bookmarks/file-bookmarks"

# generic functions
## make dirs to open editor
function v() {
    mkdir -p $(dirname $1) && $EDITOR $1
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

# options
setopt no_beep
## history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
