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
    if ! test -e "$1"; then
        echo "\"$1\": No such file or directory"
        return 1
    fi

    case "$1" in
        *.ipynb)
            if ! which jupyter >/dev/null; then
                echo "jupyter not found"
                return 1
            fi
            local TMP=$(mktemp).html
            jupyter nbconvert --to html --stdout "$1" > $TMP
            ql $TMP
            trm $TMP
            ;;
        *)
            qlmanage -p "$1" >& /dev/null
            ;;
    esac
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
    cd ~/_/dev/clones || return 1
    git clone "$1"
    cd $(basename "$_" .git)
}

# rmarkdown
# 1 arg: knit $1 to temporary file & open
# 2 args: knit to $2
function rmd() {
    if ! test -f "$1"; then
        echo "File required"
        exit 1
    fi

    local f="$(realpath "$1")"
    [[ -z "$2" ]] && local out="$(mktemp).html" || local out="$2"

    R -e "library(rmarkdown); render('$f', output_file = '$out')"
    [[ -z "$2" ]] && open "$out"
}

function mda() {
    [[ "$#" != "1" ]] && echo "Markdown file required" && return 1
    local export_f="$(mktemp)"
    mdanki --config ~/.mdanki/settings.json "$1" "$export_f"
    curl localhost:8765 -X POST -d \
        '{ "action": "importPackage", "version": 6, "params": { "path": "'"$export_f"'" } }'
}

