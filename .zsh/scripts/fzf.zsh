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
#   - ctrl+u to cd / create new directory/ies
#   - ctrl+o to write pick to buffer

fzf_file() {
    local out=$(fzf --expect=ctrl-o,ctrl-n,ctrl-u </dev/tty)
    zle reset-prompt

    local key=$(head -1 <<< $out)
    local f=$(tail -n +2 <<< $out)
    if [[ -n "$f" ]]; then
        local dir=$(dirname ${(q-)f})
        if [[ -n "$BUFFER" || "$key" == ctrl-o ]]; then LBUFFER+=${(q-)f};
        elif [[ "$key" == ctrl-n ]]; then LBUFFER="v ${(q-)dir}/";
        elif [[ "$key" == ctrl-u ]]; then BUFFER="cd ${(q-)dir}"; zle accept-line; zle reset-prompt;
        else BUFFER="$EDITOR ${(q-)f}"; zle accept-line; zle reset-prompt;
        fi
    fi
}
zle -N fzf_file
bindkey ^o fzf_file

fzf_dir() {
    local out=$(fd --type d $FD_OPTIONS 2> /dev/null \
        | fzf --expect=ctrl-o,ctrl-n,ctrl-u)
    zle reset-prompt

    local key=$(head -1 <<< $out)
    local dir=$(tail -n +2 <<< $out)
    if [[ -n "$dir" ]]; then
        if [[ -n "$BUFFER" || "$key" == ctrl-o ]]; then LBUFFER+=${(q-)dir};
        elif [[ "$key" == ctrl-n ]]; then LBUFFER="v ${(q-)dir}";
        elif [[ "$key" == ctrl-u ]]; then LBUFFER="mkdir -p ${(q-)dir}";
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
    local rg_command=("rg" "--column" "--line-number" "--no-heading")
    local selection=$($rg_command "$1" | \
        fzf -d ':' --with-nth=1 +m --disabled --print-query --query "$1" \
            --bind "change:reload:$rg_command {q} || true" \
            --preview-window="right,70%,wrap,nohidden" \
            --preview "\
                bat --style=numbers --color=always --line-range {2}: {1} 2> /dev/null\
                    | rg --color always --context 10 {q}\
                || bat --style=numbers --color=always --line-range {2}: {1} 2> /dev/null")

    local query=$(head -n 1 <<< $selection)
    local details=$(tail -n 1 <<< $selection)

    if [[ "$details" != "$query" ]]; then
        local file=$(awk -F: '{ print $1 }' <<< $details)
        local line=$(awk -F: '{ print $2 }' <<< $details)
        local column=$(awk -F: '{ print $3 }' <<< $details)
        vim "+call cursor($line, $column)" "+let @/='$query'" "+set hls" "$file" \
            && rgi "$query"
    fi
}

