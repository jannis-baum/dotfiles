#!/bin/zsh

function hl_print() {
    printf "\\033[1m$1\\033[0m\n"
}

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR=$HOME/_dotfiles

hl_print "CLONING INTO DOTFILES & INITIALIZING SUBMODULES"
printf "\\033[2m"
git clone --recurse-submodules https://github.com/jannis-baum/dotfiles $DOTFILES_DIR
cd $DOTFILES_DIR
printf "\\033[0m"

hl_print "SETTING MACOS PREFERENCES"
./setup.nosync/macos.sh

if ! which brew &> /dev/null; then
    hl_print "INSTALLING HOMEBREW"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
hl_print "INSTALLING BREW PACKAGES"
./setup.nosync/brew.sh --upgrade

hl_print "BUILDING LIB PACKAGES"
eval "$(fd --hidden Makefile .lib/nosync | sed -e 's/Makefile$//' -e 's/^/make -C /')"

hl_print "INSTALLING CONFIG"
source .zsh/scripts/sdf.zsh
jot -s '' -b y 0 | sdf
