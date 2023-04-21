# single instance vim - si_vim
# always keeps one instance of vim running in the background ready to be used
# for anything

# COMMAND BUFFER ---------------------------------------------------------------
# file that vim sources when it is taken to foreground
_si_vim_resume_source_dir=$HOME/.vim/resume-source
mkdir -p $_si_vim_resume_source_dir
_si_vim_resume_source=$_si_vim_resume_source_dir/$$.vim
# add to command buffer
function _si_vim_cmd() {
    echo "$1" >> $_si_vim_resume_source
}

# JOB --------------------------------------------------------------------------
# function to find job name in list
function _si_vim_job() {
    RESUME_SOURCE=$_si_vim_resume_source vim
}
# check if si_vim is running
function _si_vim_isrunning() {
    [[ -n "$(jobs | grep '_si_vim_job')" ]]
}

# HOOKS ------------------------------------------------------------------------
autoload -U add-zsh-hook

# ensure si_vim is always running
function _si_vim_run() {
    _si_vim_isrunning || _si_vim_job &
}
add-zsh-hook precmd _si_vim_run

# keep si_vim in same directory as zsh
function _si_vim_syncpwd() {
    _si_vim_cmd "cd $(pwd)"
}
add-zsh-hook chpwd _si_vim_syncpwd

# KEYBINDINGS ------------------------------------------------------------------
# ctrl-u to bring up si_vim
_si_vim_widget() {
    BUFFER="fg %_si_vim_job"
    zle accept-line; zle reset-prompt
}
zle -N _si_vim_widget
bindkey ^u _si_vim_widget

# USER FUNCTIONS ---------------------------------------------------------------
# make dirs to open editor
# open in running vim if suspended
function v() {
    mkdir -p $(dirname $1)
    _si_vim_cmd "SivOpen $1"
    fg %_si_vim_job
}
