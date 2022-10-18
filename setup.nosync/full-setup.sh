#!/bin/zsh

function hl_print() {
    printf "\\033[1m$1\\033[0m\n"
}

dotfiles_dir=$HOME/_dotfiles

hl_print "CLONING REPO & INITIALIZING SUBMODULES"
printf "\\033[2m"
git clone --recurse-submodules https://github.com/jannis-baum/dotfiles $dotfiles_dir
printf "\\033[0m"

hl_print "SETTING MACOS PREFERENCES"
$dotfiles_dir/setup/macos.sh

hl_print "INSTALLING BREW PACKAGES"
$dotfiles_dir/setup/brew.sh --upgrade

hl_print "INSTALLING CONFIG"
source $dotfiles_dir/../.zsh/scripts/sdf.zsh
jot -s '' -b y 0 | sdf
