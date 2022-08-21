function _git_pretty_diff() {
    paste -d '\0' \
        <(git diff --name-status $1 $2 | sed -r 's/^([^[:blank:]]).*$/\1/') \
        <(git diff --stat=120 --color=always $1 $2)
}

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
