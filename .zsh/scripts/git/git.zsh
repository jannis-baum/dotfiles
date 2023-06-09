alias gs="git status -s"
alias gca="git commit --amend"
alias grc="git rebase --continue"
alias gp="git push"
alias gpf="git push --force"
alias gpp="git pull && gprune-branches"
alias gx="git config --get remote.origin.url | xargs open"
alias gst="git stash"
alias gsp="git stash pop"

# stage all or given files/dirs
function ga() {
    [[ $# -eq 0 ]] && git add --all || git add $*
    gs
}

# unstage all or given files/dirs
function gr() {
    if [[ $# -eq 0 ]]; then
       git restore --staged $(git rev-parse --show-toplevel)
   else
       git restore --staged $*
    fi
    gs
}

# interactive staging
# - left arrow: toggle staging
# - ctrl+r: prompt to reset changes
# - ctrl+v: open diff view
# - ctrl+o: commit
# - ctrl+b: amend commit
# - return: open file
function gsi() {
    local out key file
    out=$(_git_interactive_status_helper \
        | fzf --ansi --exit-0 --delimiter ':' --with-nth 2 --expect=left,ctrl-r,ctrl-v,ctrl-o,ctrl-b \
            --preview="git diff --color=always HEAD -- {1} | tail -n +5" \
            --preview-window='60%,nowrap,nohidden')

    key=$(head -1 <<< $out)
    file=$(tail -n +2 <<< $out | sed -r 's/^([^:]*):.*$/\1/')

    [[ -z "$file" ]] && return

    if [[ "$key" == left ]]; then; _git_toggle_staging $file && gsi
    elif [[ "$key" == ctrl-r ]]; then; greset "$file" && gsi
    elif [[ "$key" == ctrl-v ]]; then; git difftool HEAD -- "$file" && gsi
    elif [[ "$key" == ctrl-o ]]; then; gc
    elif [[ "$key" == ctrl-b ]]; then; gca
    else $EDITOR $file; fi
}

# commit
# if branch follows `issue/NUMBER-title` scheme will copy issue ref
# as conventional commit context
function gc() {
    local context=$(_gh_get_branch_issue)
    [[ -n "$context" ]] && printf "(#$context): " | pbcopy
    git commit
}

# checkout
# automatically creates local copies of remote branches
function gco() {
    local branch
    branch=$(git branch -a \
        | sed -e 's/^..//' -e '/->/d' -e 's,^remotes/origin/,,' \
        | sort -u | fzf)
    [[ -n $branch ]] && (git checkout $branch 2>/dev/null || git checkout -b $branch)
}

# reset changes of all or given files
function greset() {
    local changes
    [[ $# -eq 0 ]] && changes="all changes" || changes="$*"
    printf "reset $changes? (y/*) "
    read -q && printf "\n" || {printf "\n" && return}

    if [[ $# -eq 0 ]]; then
        git reset --hard
        return
    fi
    git checkout HEAD -- $*
}

# fzf to see diff to parent commit or between given commits
# shows preview and opens difftool on return
# offers zsh completion
function gd() {
    local out key file
    out=$(_git_pretty_diff $1 $2 | sed '$d' \
        | fzf --ansi --exit-0 --delimiter=' ' --expect=ctrl-o \
            --preview="git diff --color=always $1 $2 -- $(git rev-parse --show-toplevel)/{2} | tail -n +5" \
            --preview-window='60%,nowrap,nohidden' \
        | sed -r 's/^. *([^[:blank:]]*) *\|.*$/\1/')

    key=$(head -1 <<< $out)
    file=$(tail -n +2 <<< $out)

    [[ -z "$file" ]] && return
    file="$(git rev-parse --show-toplevel)/$file"

    if [[ "$key" == ctrl-o ]]; then $EDITOR $file;
    else git difftool $1 $2 -- "$file" && gd $1 $2;
    fi
}
function _MINE_git_branch_names() {
    compadd "${(@)${(f)$(git branch -a)}#??}"
}
compdef _MINE_git_branch_names gd

# fzf to see git log
# log args:
# - uses `git log main..` if not on main branch (uses remote head branch if
#                                                main doesn't exist)
#   - first arg -a or --all to avoid this
# - otherwise passes args to git log
# bindings:
# - ctrl-r starts rebase from parent of selected commit
# - ctrl-o copies commit hash
# - return opens diff (gd, see above) between commit and parent
function gl() {
    local commit hash key logargs

    if [ -n "$*" ]; then
        [ "$1" = "-a" -o "$1" = "--all" ] \
            && logargs="" || logargs="$1"
    else
        local head_branch=""
        git rev-parse --verify main &>/dev/null \
            && head_branch="main" \
            || head_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
        [ $(git branch --show-current) = "$head_branch" ] \
            && logargs="" || logargs="$head_branch.."
    fi

    out=$(git log --oneline --decorate --color=always $logargs \
        | fzf --delimiter=' ' --with-nth='2..' --no-sort --exact --ansi --expect=ctrl-r,ctrl-o \
            --preview 'zsh -c "source $ZDOTDIR/scripts/git/_helpers.zsh 2> /dev/null;
                _git_pretty_diff $(git log --pretty=%P -n 1 {1}) {1} | less -R"' \
            --preview-window='60%,nowrap,nohidden')

    key=$(head -1 <<< $out)
    hash=$(tail -n +2 <<< $out | sed 's/ .*$//')

    if [ -n "$hash" ]; then
        if [[ "$key" == ctrl-r ]]; then git rebase -i $hash^;
        elif [[ "$key" == ctrl-o ]]; then printf $hash | pbcopy;
        else gd $(git log --pretty=%P -n 1 $hash) $hash; gl;
        fi
    fi
}

# delete branches that don't have remote
# -f to also force delete branches that aren't fully merged
function gprune-branches() {
    local flag="-d"
    git fetch --prune
    [[ "$1" == "-f" || "$1" == "--force" ]] && flag="-D"
    git branch -vv \
        | rg ': gone] ' | rg -v '^\*' \
        | awk '{ print $1 }' \
        | xargs -r git branch $flag
}
