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

function _write_v_jobs() {
    _get_vim_ids | wc -l > "/tmp/current-jobs-$$"
}

# function to find job name in list
function __si_vim() {
    vim
}
# check if si_vim is running
function _si_vim_isrunning() {
    [[ -n "$(jobs | grep '__si_vim')" ]]
}

# ensure si_vim is always running
autoload -U add-zsh-hook
function _si_vim_run() {
    _si_vim_isrunning || __si_vim &
}
add-zsh-hook precmd _si_vim_run
