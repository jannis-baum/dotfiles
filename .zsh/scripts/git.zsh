alias gs="git status -s"
alias gca="git commit --amend --no-edit"

function ga() {
    [[ $# -eq 0 ]] && git add --all || git add $*
    git status -s
}

function gr() {
    if [[ $# -eq 0 ]]; then
       git restore --staged $(git rev-parse --show-toplevel)
   else
       git restore --staged $*
    fi
    git status -s
}

function gc() {
    [[ $# -eq 0 ]] && git commit || git commit -m "$*"
}

function gco() {
    local branch
    branch=$(git branch -a | sed -e 's/^..//' -e '/->/d' -e 's,^remotes/origin/,,' | sort -u | fzf)
    [[ -n $branch ]] && (git checkout $branch 2>/dev/null || git checkout -b $branch)
}

function gl() {
    local commit hash key
    out=$(git log --oneline --decorate --color=always \
        | fzf --delimiter=' ' --with-nth='2..' --no-sort --exact --ansi --expect=ctrl-r)
    key=$(echo $out | head -1)
    hash=$(echo $out | tail -n +2 | sed 's/ .*$//')
    if [ -n "$hash" ]; then
        if [ "$key" = ctrl-r ]; then git rebase -i $hash^;
        else printf $hash | pbcopy;
        fi
    fi
}

function gd() {
    local file
    file=$(git diff --stat=120 --color=always $1 \
        | sed '$d' \
        | fzf --ansi --exit-0 \
        | sed -r 's/^ *([^[:blank:]]*) *\|.*$/\1/')
    [[ -n "$file" ]] && git difftool $1 "$file"
}
function _MINE_git_branch_names() {
    compadd "${(@)${(f)$(git branch -a)}#??}"
}
compdef _MINE_git_branch_names gd

# shows number of line changes for each commit, almost never useful
# but want to keep it somewhere
#function glc() {
#    git log --reverse --oneline --decorate --shortstat --color=always \
#    | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n / /g' \
#    | sed -r -e 's/([0-9]+) files? changed/\x1b[34m\1: /g' \
#        -e 's/, ([0-9]+) insertions?\(\+\)/\x1b[32m+\1 /g' \
#        -e 's/, ([0-9]+) deletions?\(-\)/\x1b[31m-\1/g' \
#        -e 's/$/\x1b[0m/' \
#    | vim-ansi-pager
#}
