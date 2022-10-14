# list GitHub issues
# ctrl-o copies #issue-number
# ctrl-b creates/checks out branch by `issue/NUMBER-title` scheme
# return opens issue in browser
function ghi() {
    local out key issue

    out=$(GH_FORCE_TTY='45%' gh issue list \
        | fzf --ansi --header-lines 3 --expect=ctrl-b,ctrl-o\
            --preview-window='50%,nowrap,nohidden' \
            --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh issue view {1}')

    key=$(head -1 <<< $out)
    issue=$(tail -n +2 <<< $out | sed -r 's/^#([[:digit:]]+) .*/\1/')

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

# open branch issue
function ghio() {
    local issue=$(_gh_get_branch_issue)
    if [ -z "$issue" ]; then
        echo "Branch doesn't follow issue naming convention. Exiting."
        return
    fi
    gh issue view --web $issue
}

# create GitHub PR for current branch that follows
# `issue/NUMBER-title` scheme.
# uses issue title as PR title and adds PR body to close issue
# opens created PR in browser
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
