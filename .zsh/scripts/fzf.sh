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
    local file
    file=$(fzf-tmux -p </dev/tty)
    if [ -n "$file" ]; then
        BUFFER="${EDITOR} ${(q-)file}"
        zle accept-line
        zle reset-prompt
    fi
}
zle -N fzf_open_editor 
bindkey ^o fzf_open_editor

