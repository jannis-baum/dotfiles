function _get_vim_ids() {
    jobs | sed -E -n 's/\[([0-9])\][ +-]* [a-zA-Z]*[[:space:]]*v .*/\1/p'
}

# make dirs to open editor
# open in running vim if suspended
function v() {
    mkdir -p $(dirname $1)

    local vim_id=$(_get_vim_ids | head -1)
    if [[ -n "$vim_id" ]]; then
        echo "tabedit $1\nfiletype detect" > $HOME/.vim/resume-source.vim
        fg %$vim_id
    else
        vim $1
    fi
}
