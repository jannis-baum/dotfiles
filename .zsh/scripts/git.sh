alias gs="git status -s"
alias gca="git commit --amend --no-edit"
alias gal="git add -A && git status -s"
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
    git commit -m "$*"
}
