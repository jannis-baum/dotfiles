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

# knit & open rmarkdown file
function rmd() {
    if ! test -f "$1"; then
        echo "File required"
        exit 1
    fi

    local f="$(realpath "$1")"
    local out="$(mktemp).html"
    R -e "library(rmarkdown); render('$f', output_file = '$out')"
    open "$out"
}

function mda() {
    [[ "$#" != "1" ]] && echo "Markdown file required" && return 1
    local export_f="$(mktemp)"
    mdanki --config ~/.mdanki/settings.json "$1" "$export_f"
    curl localhost:8765 -X POST -d \
        '{ "action": "importPackage", "version": 6, "params": { "path": "'"$export_f"'" } }'
}

