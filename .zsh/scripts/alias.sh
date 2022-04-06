# linking scripts
alias mue="~/_lib/markup-export/main"
alias cookie-cleaner="~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt"
alias desknotes="~/_lib/desktop-notes/desknotes"
alias pass="~/_lib/keychains/main"
alias fbm="~/_lib/file-bookmarks/file-bookmarks"

# generic aliases
alias cl="clear"
alias kl="cookie-cleaner && quit-apps"
alias sdf="sync-dotfiles"
alias ej="eject /Volumes/LaCie"
alias karabiner-cli="/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
alias convert-file="ffmpeg"
## list / exa
unalias l
alias l="exa --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"
unalias la
alias la="exa --long --all --git --no-permissions --no-user --ignore-glob='.DS_Store' --group-directories-first --time-style=iso"
alias t="exa --long --no-user --no-permissions --no-filesize --no-time --git --tree --git-ignore --all --ignore-glob='.git|node_modules|.DS_Store' --group-directories-first"

