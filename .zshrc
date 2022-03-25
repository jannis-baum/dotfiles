export ZSH="${HOME}/.oh-my-zsh"
export PATH="${PATH}:${HOME}/_bin:${HOME}/.flutter/bin:/Applications/Postgres.app/Contents/Versions/latest/bin/"

# theme: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="minimal"

source $ZSH/oh-my-zsh.sh

# prompt
export PS1="%F{189}✻%f %2~ » "

# linking scripts
alias mue="~/_lib/markup-export/main"
alias cookie-cleaner="~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt"
alias desknotes="~/_lib/desktop-notes/desknotes"
alias pass="~/_lib/keychains/main"
alias fbm="~/_lib/file-bookmarks/file-bookmarks"


# generic aliases
alias cl="clear"
alias kl="cookie-cleaner && quit-apps"
alias sdf="sync-dotfiles"
alias ej="eject /Volumes/LaCie"
alias karabiner-cli="/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
alias convert-file="ffmpeg"
# tree
export TREE_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
alias ta="tree -C -a -L 1 --noreport --dirsfirst -I '.DS_Store' -I '.git/'"
alias t="ta --gitignore"


# generic functions
unalias l
function l() {
    (cd ${1:-.} && unbuffer find . -maxdepth 1 ! -name '.DS_Store' ! -name '.git' ! -name . -exec ls -Cd --color=always {} + | sed "s,./,,g")
}
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


# git
alias gs="git status -s"
alias gca="git commit --amend --no-edit"
function ga() {
    git add $* && git status -s
}
function gr() {
    git restore --staged $* && git status -s
}
function gc() {
    git commit -m "$*"
}

# vi keybindings
bindkey -v

# fzf autocompletion
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

