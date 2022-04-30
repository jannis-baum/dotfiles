# directory as cmd cd's there
setopt auto_cd
# cd stack
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

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

alias s="COLUMNS=120 exa --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"
alias l="exa --long --all --git --no-permissions --no-user --ignore-glob='.DS_Store' --group-directories-first --time-style=iso"
alias t="exa --long --no-user --no-permissions --no-filesize --no-time --git --tree --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first --git-ignore"
alias ta="exa --long --no-user --no-permissions --no-filesize --no-time --git --tree --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"

# make and change to directory
function mcd() {
    test -d "$1" || mkdir "$1" && cd "$1"
}
# list newest (date changed) files
function ln() {
	ls -t $2 | head -$1
}
# lsn-do NEWEST_N PATH COMMAND
function lnp() {
    ls -t $2 | head -$1 | sed 's,^,'$2'\/,'
}
