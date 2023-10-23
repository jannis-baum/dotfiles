# generate new password
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
# quick look
function ql() {
    if test -e "$1"; then
        qlmanage -p "$1" >& /dev/null
    else
        echo "\"$1\": No such file or directory"
    fi
}
# pip installed version for requirements.txt
function pipf() {
    pip3 freeze | rg "$1" | sed 's/==/>=/' | pbcopy
}
# reload color schemes
function rcols() {
    make -C ~/_dotfiles/.lib/nosync/color-schemes load
    source $ZDOTDIR/.zshrc
    _si_vim_isrunning && _si_vim_cmd ReloadConfig
}
# clone repo in clones dir & cd there
function gclo() {
    [[ "$#" != "1" ]] && echo "Repo URL required" && return 1
    cd ~/_/development/clones
    git clone "$1"
    cd $(basename "$_" .git)
}