alias gs="git status -s"
alias gca="git commit --amend"
alias grc="git rebase --continue"
alias gp="git push"
alias gpf="git push --force"

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
    branch=$(git branch -a \
        | sed -e 's/^..//' -e '/->/d' -e 's,^remotes/origin/,,' \
        | sort -u | fzf)
    [[ -n $branch ]] && (git checkout $branch 2>/dev/null || git checkout -b $branch)
}

function greset() {
    if [[ $# -eq 0 ]]; then
        git reset --hard
        return
    fi
    git checkout HEAD -- $*
}

function _git_pretty_diff() {
    paste -d '\0' \
        <(git diff --name-status $1 $2 | sed -r 's/^([^[:blank:]]).*$/\1/') \
        <(git diff --stat=120 --color=always $1 $2)
}

function gd() {
    local file
    file=$(_git_pretty_diff $1 $2 | sed '$d' \
        | fzf --ansi --exit-0 --delimiter=' ' \
            --preview="git diff --color=always $1 $2 -- $(git rev-parse --show-toplevel)/{2} | tail -n +5" \
            --preview-window='60%,nowrap,nohidden' \
        | sed -r 's/^. *([^[:blank:]]*) *\|.*$/\1/')
    [[ -n "$file" ]] && git difftool $1 $2 -- "$(git rev-parse --show-toplevel)/$file" && gd $1 $2
}
function _MINE_git_branch_names() {
    compadd "${(@)${(f)$(git branch -a)}#??}"
}
compdef _MINE_git_branch_names gd

function gl() {
    local commit hash key
    out=$(git log --oneline --decorate --color=always \
        | fzf --delimiter=' ' --with-nth='2..' --no-sort --exact --ansi --expect=ctrl-r,ctrl-o \
            --preview 'zsh -c "source $ZDOTDIR/scripts/git.zsh 2> /dev/null;
                _git_pretty_diff $(git log --pretty=%P -n 1 {1}) {1} | less -R"' \
            --preview-window='60%,nowrap,nohidden')
    key=$(echo $out | head -1)
    hash=$(echo $out | tail -n +2 | sed 's/ .*$//')
    if [ -n "$hash" ]; then
        if [[ "$key" == ctrl-r ]]; then git rebase -i $hash^;
        elif [[ "$key" == ctrl-o ]]; then printf $hash | pbcopy;
        else gd $(git log --pretty=%P -n 1 $hash) $hash; gl;
        fi
    fi
}

function gprune-branches() {
    local flag="-d"
    git fetch --prune
    [[ "$1" == "-f" || "$1" == "--force" ]] && flag="-D"
    git branch -vv \
        | rg ': gone] ' | rg -v '^\*' \
        | awk '{ print $1 }' \
        | xargs -r git branch $flag
}
