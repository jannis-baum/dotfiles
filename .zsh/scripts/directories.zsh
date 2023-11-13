# directory as cmd cd's there
setopt auto_cd
# cd stack
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias d=cd
alias df=cdf

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias s="exa --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"
alias l="exa --long --all --git --no-permissions --no-user --ignore-glob='.DS_Store' --group-directories-first --time-style=iso"
alias ts="s --long --no-user --no-permissions --no-time --tree --group-directories-first"
alias ta="exa --long --no-user --no-permissions --no-filesize --no-time --git --tree --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"
alias t="ta --git-ignore --level=5"

# make and change to directory
function mcd() {
    test -d "$1" || mkdir "$1" && cd "$1"
}
# list newest files with absolute paths for piping
function sna() {
    local count=1
    local dir="."
    [[ $# -eq 1 ]] && dir="$1"
    [[ $# -eq 2 ]] && count="$1" && dir="$2"

    echo "$(\
        SI_VIM_DISABLED=1
        cd "$dir"; \
        entries=$(exa --sort=oldest | head -n "$count"); \
        echo ${(F)${(f)entries}:P})"
}
alias downl="sna ~/Downloads"
