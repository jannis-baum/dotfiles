function _git_interactive_status_helper() {
    local work_dir=$(pwd)
    paste -d '\0' \
        <(git status --short \
            | sed -e 's/^...//' -e 's/$/:/' -e "s|^|$work_dir/|") \
        <(COLOR=always git --config-env=color.status=COLOR status --short) \
        <(git diff --stat=120 --color=always HEAD \
            | sed '$d' \
            | rev \
            | sed -r 's/^(.*\|[[:blank:]]*)[^[:blank:]].*$/\1/' \
            | rev)
}

function _git_toggle_staging() {
    if [[ -n $(git diff -- $1) ]]; then
        git add $1
    else
        git restore --staged $1 2> /dev/null || git add $1
    fi
}

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

function _gh_get_branch_name_for_issue() {
    echo "issue/$1-$(_gh_get_issue_title $1 \
        | tr ' ' '-' \
        | tr -cd '[:alnum:]-' \
        | tr '[:upper:]' '[:lower:]' \
        | sed -r 's/--+/-/g')"
}

function _gh_checkout_issue_branch() {
    local branch=$(_gh_get_branch_name_for_issue $1)
    git checkout $branch 2>/dev/null \
        || git checkout -b $branch
}
