alias gs="git status -s"
alias gt="git tree"
alias gca="git commit --amend --no-edit"

function ga() {
    if [[ $# -eq 0 ]]; then
        git add --all
    else
        git add $*
    fi
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
