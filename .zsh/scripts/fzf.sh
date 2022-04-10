# use fd for fzf '**' shell completions.
_fzf_compgen_path() {
  command fd --hidden --follow --exclude .git --exclude node_modules . "$1"
}
# use fd to generate the list for directory completion
_fzf_compgen_dir() {
  command fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
}
# fzf autocompletion
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

fzf_open_editor() {
    local f
    f=$(fzf-tmux -p </dev/tty)
    if [ -n "$f" ]; then
        BUFFER="${EDITOR} ${(q-)f}"
        zle accept-line
        zle reset-prompt
    fi
}
zle -N fzf_open_editor 
bindkey ^o fzf_open_editor

fzf_pick_file() {
    local f
    f=$(fzf-tmux -p </dev/tty)
    LBUFFER+=${(q-)f}
}
zle -N fzf_pick_file
bindkey ^p fzf_pick_file

