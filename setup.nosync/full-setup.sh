#!/bin/zsh

function hl_print() {
    printf "\\033[1m$1\\033[0m\n"
}

[[ -n "$DOTFILES_DIR" ]] && DOTFILES_DIR=$HOME/_dotfiles

hl_print "CLONING INTO DOTFILES & INITIALIZING SUBMODULES"
printf "\\033[2m"
git clone --recurse-submodules https://github.com/jannis-baum/dotfiles $DOTFILES_DIR
printf "\\033[0m"

hl_print "SETTING MACOS PREFERENCES"
$DOTFILES_DIR/setup/macos.sh

if ! which brew &> /dev/null; then
    hl_print "INSTALLING HOMEBREW"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
hl_print "INSTALLING BREW PACKAGES"
$DOTFILES_DIR/setup/brew.sh --upgrade

hl_print "INSTALLING CONFIG"
source $DOTFILES_DIR/../.zsh/scripts/sdf.zsh
jot -s '' -b y 0 | sdf
