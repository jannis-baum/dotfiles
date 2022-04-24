# basic setup ------------------------------------------------------------------
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


# key bindings -----------------------------------------------------------------

# ctrl+o|u for file|directory picker
#   - enter opens file in editor | cds to directory
#   - ctrl+n for new file (path can have new directories)
#   - ctrl+u for new directory/ies
#   - ctrl+o to write pick to buffer

fzf_file() {
    local out key f dir
    local fzf_opts="--expect=ctrl-n,ctrl-u,ctrl-o"
    if [ -n "$TMUX" ]; then
        out=$(fzf-tmux -p -- $fzf_opts </dev/tty)
    else
        out=$(fzf $fzf_opts </dev/tty)
        zle reset-prompt
    fi
    key=`echo $out | head -1`
    f=`echo $out | tail -n +2`
    if [ -n "$f" ]; then
        dir=`dirname ${(q-)f}`
        if   [ "$key" = ctrl-n ]; then LBUFFER="v ${(q-)dir}/";
        elif [ "$key" = ctrl-u ]; then BUFFER="cd ${(q-)dir}"; zle accept-line; zle reset-prompt;
        elif [ "$key" = ctrl-o ]; then LBUFFER+=${(q-)f};
        else BUFFER="$EDITOR ${(q-)f}"; zle accept-line; zle reset-prompt;
        fi
    fi
}
zle -N fzf_file
bindkey ^o fzf_file

fzf_dir() {
    local out key dir
    local fzf_opts="--expect=ctrl-n,ctrl-u,ctrl-o"
    if [ -n "$TMUX" ]; then
        out=$(fd --type d $FD_OPTIONS 2> /dev/null | fzf-tmux -p -- $fzf_opts)
    else
        out=$(fd --type d $FD_OPTIONS 2> /dev/null | fzf $fzf_opts)
        zle reset-prompt
    fi
    key=`echo $out | head -1`
    dir=`echo $out | tail -n +2`
    if [ -n "$dir" ]; then
        if   [ "$key" = ctrl-n ]; then LBUFFER="v ${(q-)dir}/";
        elif [ "$key" = ctrl-u ]; then LBUFFER="mkdir -p ${(q-)dir}/";
        elif [ "$key" = ctrl-o ]; then LBUFFER+=${(q-)dir};
        else BUFFER="cd ${(q-)dir}"; zle accept-line; zle reset-prompt;
        fi
    fi
}
zle -N fzf_dir
bindkey ^u fzf_dir


# other ------------------------------------------------------------------------

# interactive ripgrep: live search & highlighted preview
# enter opens selection in vim, goes to selected occurance and highlights search
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

