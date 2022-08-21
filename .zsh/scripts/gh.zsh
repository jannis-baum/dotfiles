function _gh_get_branch_issue() {
    git branch --show-current \
        | rg '^issue/' \
        | sed -r 's:^issue/([[:digit:]]+)-.*:\1:'
}

function _gh_get_issue_title() {
    gh issue view $1 \
        | rg 'title:' \
        | sed -r 's/^title:[[:blank:]]*//'
}

function ghi() {
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
            branch="issue/$issue-$(_gh_get_issue_title $issue \
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

function ghpr() {
    local issue=$(_gh_get_branch_issue)
    if [ -z "$issue" ]; then
        echo "Branch doesn't follow issue naming convention. Exiting."
        return
    fi

    local title=$(_gh_get_issue_title $issue)
    gh pr create --title $title --body "Close #$issue" \
        | tail -n 1 | xargs open
}
