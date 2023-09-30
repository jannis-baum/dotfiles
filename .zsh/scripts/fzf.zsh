# command to list directory contents in preview window (for fzf-dotfiles)
FZFDF_LS=$(which l | sed 's/^l: aliased to //')

# find large & old files
function large-files() {
    mdfind '((kMDItemPhysicalSize > 50000000)
        && (kMDItemLastUsedDate  < $time.today(-30d))
        && (kMDItemFSContentChangeDate < $time.today(-90d)))' \
    | sed -e "s/^/'/" -e "s/$/'/" \
    | xargs exa \
        --long --no-permissions --no-user --time-style=iso \
        --all --ignore-glob='.DS_Store' \
        --list-dirs \
        --sort=size --reverse \
        --color=always \
    | fzf --ansi -d ' ' \
        --bind 'return:execute(open $(dirname {3..}))'
}

# select makefile target
function mkf() {
    # list make targets: adjusted from https://stackoverflow.com/a/26339924
    local target=$(make -pRrq : 2>/dev/null \
        | awk -v RS= -F: '/(^|\n)# Files(\n|$)/,/(^|\n)# Finished Make data base/ {if ($1 !~ "^[#.]") {print $1}}' \
        | sort \
        | grep -E -v -e '^[^[:alnum:]]' -e '^$@$' \
        | fzf)
    [[ -z "$target" ]] && return
    make "$target"
}
