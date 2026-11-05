# macOS /etc/zprofile is sourced after ~/.zshenv so we put this here so it doesn't mess up the order
export PATH=$(tr -d ' ' <<<"\
    $HOME/.local/bin\
    :/opt/homebrew/bin\
    :/Library/TeX/texbin\
    :/opt/homebrew/opt/postgresql@17/bin\
    :$HOME/.flutter/bin\
    :$HOME/.pub-cache/bin\
    :$PATH
")
