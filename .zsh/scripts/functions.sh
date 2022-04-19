# generic functions
function v() {
    mkdir -p $(dirname $1) && $EDITOR $1
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

