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
