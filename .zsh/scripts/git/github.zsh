# list GitHub issues
# ctrl-o copies #issue-number
# ctrl-b creates/checks out branch by `issue/NUMBER-title` scheme
# return opens issue in browser
function ghi() {
    local out key issue

    out=$(GH_FORCE_TTY='45%' gh issue list --limit 100 \
        | fzf --ansi --header-lines 3 --expect=ctrl-b,ctrl-o\
            --preview-window='50%,nowrap,nohidden' \
            --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh issue view {1}')

    key=$(head -1 <<< $out)
    issue=$(tail -n +2 <<< $out | sed -r 's/^#([[:digit:]]+) .*/\1/')

    if [ -n "$issue" ]; then
        if [[ "$key" == ctrl-o ]]; then
            printf "#$issue" | pbcopy
        elif [[ "$key" == ctrl-b ]]; then
            _gh_checkout_issue_branch $issue
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
        return 1
    fi
    gh issue view --web $issue
}

# create issue & go to branch
# useful when doing something we don't have an issue for
function ghin() {
    if [ -z "$1" ]; then
        echo "Please specify an issue name."
        return 1
    fi
    local issue=$(gh issue create --title "$*" --body "" \
        | tail -1 \
        | sed -r 's|^.*/([[:digit:]]+)$|\1|')
    [ -n "$issue" ] && _gh_checkout_issue_branch $issue
}

# rename current issue & branch
function ghir() {
    local issue=$(_gh_get_branch_issue)
    if [ -z "$1" -o -z "$issue" ]; then
        return 1
    fi
    gh issue edit $issue --title "$*"
    git push origin --delete $(git branch --show-current)
    local newname=$(_gh_get_branch_name_for_issue $issue)
    git branch -m $newname
    git push origin -u $newname
}

# if PR exists for branch, open PR. if not:
# create PR for current branch that follows `issue/NUMBER-title` scheme.  uses
# issue title as PR title and adds PR body to close issue. if branch doesn't
# follow scheme, uses branch name as title and empty body. opens created PR in
# browser.
function ghpr() {
    gh pr view --web 2>/dev/null && return

    local title=$(git branch --show-current)
    local issue=$(_gh_get_branch_issue)
    local body=""
    if [ -n "$issue" ]; then
        title=$(_gh_get_issue_title $issue)
        body="Close #$issue"
    fi

    gh pr create --title $title --body "$body" \
        | tail -n 1 | xargs open
}
