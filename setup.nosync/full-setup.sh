#!/bin/zsh

function hl_print() {
    printf "\\033[1m$1\\033[0m\n"
}

dir=$(dirname $(realpath $0))

hl_print "SETTING MACOS PREFERENCES"
$dir/macos.sh

hl_print "INSTALLING BREW PACKAGES"
$dir/brew.sh --upgrade

hl_print "INSTALLING CONFIG"
source $dir/../.zsh/scripts/sdf.zsh
jot -s '' -b y 0 | sdf
