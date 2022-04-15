alias gs="git status -s"
alias gca="git commit --amend --no-edit"
alias gal="git add -A && git status -s"
function ga() {
    git add $* && git status -s
}
function gr() {
    git restore --staged $* && git status -s
}
function gc() {
    git commit -m "$*"
}
