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

rgi() {
    local rg_command="rg --column --line-number --no-heading "
    selection=$(true | \
        fzf -d ':' --with-nth=2 +m --bind "change:reload:$rg_command {q} | sed 's/^/{q}:/g' || true" --disabled \
            --preview-window="right,70%,wrap" --preview "bat --style=numbers --color=always --line-range {3}: {2} 2> /dev/null\
                | rg --color always --context 10 '{q}'")
    if [[ -n "$selection" ]]; then
        local query=$(echo $selection | awk -F: '{ print $1 }')  
        local file=$(echo $selection | awk -F: '{ print $2 }')
        local line=$(echo $selection | awk -F: '{ print $3 }')
        local column=$(echo $selection | awk -F: '{ print $4 }')
        vim "+call cursor($line, $column)" "+let @/='$query'" "+set hls" "$file"
    fi
}

