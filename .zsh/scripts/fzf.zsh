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

# command to list directory contents in preview window
_fzf_ls_cmd=$(which l | sed 's/^l: aliased to //')

# key bindings -----------------------------------------------------------------

# ctrl+o for finder
#   - enter    open file in editor / cds to directory
#   - ctrl+n   create new file (path can have new directories)
#   - ctrl+u   start finder in selected directory (/ directory of selected file)
#   - ctrl+o   write pick to buffer (also happens when buffer not empty)
#   - left     reload without ignoring anything (e.g. .git/*)

_fzf_finder() {
    [[ -z "$1" ]] && local target_dir="." || local target_dir=$1

    local fd_opts=("--follow" "--strip-cwd-prefix" "--color=always" \
        "--hidden" "--exclude" '**/.git/')
    local out=$(fd $fd_opts --full-path $1 \
        | fzf --ansi \
            --expect=ctrl-o,ctrl-n,ctrl-u \
            --preview="test -d {} \
                && $_fzf_ls_cmd {} \
                || bat --style=numbers --color=always {}" \
            --preview-window="nohidden" \
            --bind "left:reload(fd --no-ignore $fd_opts)")
    zle reset-prompt

    local key=$(head -1 <<< $out)
    local pick=$(tail -n +2 <<< $out)
    [[ -z "$pick" ]] && return

    pick=${(q-)pick}
    test -d $pick \
        && local dir="$pick" \
        || local dir="${(q-)$(dirname $pick)}/"

    if [[ -n "$BUFFER" || "$key" == ctrl-o ]]; then
        LBUFFER+="$pick"
    elif [[ "$key" == ctrl-n ]]; then
        LBUFFER="$EDITOR $dir"
    elif [[ "$key" == ctrl-u ]]; then
        _fzf_finder "$dir" || _fzf_finder "$target"
    else
        test -d $pick \
            && BUFFER="cd $pick" \
            || BUFFER="$EDITOR $pick"
        zle accept-line; zle reset-prompt
    fi
}
zle -N _fzf_finder
bindkey ^o _fzf_finder

# commands ---------------------------------------------------------------------

# interactive ripgrep: live search & highlighted preview
#   - enter    open selection in vim, go to selected occurance and highlight
#              search 
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
        $EDITOR "+call cursor($line, $column)" "+let @/='$query'" "+call feedkeys('/\<CR>')" "$file"
    fi
}

# dir history picker
#   - enter    go to directory
function df() {
    # make paths unique and delete non-existing
    local valid_paths=""
    for p in $(
        cat -n $ZSH_DIR_HIST_FILE \
            | sort -uk2 \
            | sort -nk1 \
            | cut -f2-
    ); do
        test -d $p && valid_paths+=$p"\n"
    done
    echo $valid_paths > $ZSH_DIR_HIST_FILE

    # pick target
    local target=$(
        printf "\e[$(sed -r 's/^.*di=([^:]+):.*$/\1/' <<< $LS_COLORS)m$(printf $valid_paths | tail -n +2)" \
        | fzf --ansi --preview-window="nohidden" \
            --preview="$_fzf_ls_cmd "'$(sed "s|~|$HOME|" <<<{})')

    # go to dir
    if [[ -n "$target" ]]; then
        cd ${(q-)$(sed "s|~|$HOME|" <<<$target)}
    fi
}

# find large & old files
function large-files() {
    mdfind '((kMDItemPhysicalSize > 50000000)
        && (kMDItemLastUsedDate  < $time.today(-30d))
        && (kMDItemFSContentChangeDate < $time.today(-90d)))' \
    | sed -e "s/^/'/" -e "s/$/'/" \
    | xargs exa \
        --long --no-permissions --no-user --time-style=iso \
        --all --ignore-glob='.DS_Store' \
        --list-dirs \
        --sort=size --reverse \
        --color=always \
    | fzf --ansi -d ' ' \
        --bind 'return:execute(open $(dirname {3..}))'
}
