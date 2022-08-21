function gi() {
    local out key issue

    out=$(GH_FORCE_TTY='45%' gh issue list \
        | fzf --ansi --header-lines 3 --expect=ctrl-b,ctrl-o\
            --preview-window='50%,nowrap,nohidden' \
            --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh issue view {1}')

    key=$(echo $out | head -1)
    issue=$(echo $out | tail -n +2 | sed -r 's/^#([[:digit:]]+) .*/\1/')

    if [ -n "$issue" ]; then
        if [[ "$key" == ctrl-o ]]; then
            printf "#$issue" | pbcopy
        elif [[ "$key" == ctrl-b ]]; then
            local branch
            branch="issue/$issue-$(gh issue view $issue \
                | rg 'title:' \
                | sed -r 's/^title:[[:blank:]]*//' \
                | tr ' ' '-' \
                | tr -cd '[:alnum:]-' \
                | tr '[:upper:]' '[:lower:]' \
                | sed -r 's/--+/-/g')"
            git checkout -b $branch 2>/dev/null \
                || git checkout $branch
        else
            gh issue view --web $issue
        fi
    fi
}
