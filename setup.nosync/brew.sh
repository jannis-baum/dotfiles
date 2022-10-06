#!/bin/bash

function hl_print() {
    printf "🔬🧪 \\033[1m$1\\033[0m\n"
}

function brew_() {
    printf "\\033[2m"
    HOMEBREW_NO_COLOR=1 brew $@
    printf "\\033[0m"
}

hl_print "running brew update"
brew_ update
if [[ "$1" == "-u" ]] || [[ "$1" == "--upgrade" ]]; then
    hl_print "running brew upgrade"
    brew_ upgrade
fi

dir=$(dirname $(realpath $0))

hl_print "checking installed packages"
installed=$(brew leaves)
packages=()
while IFS= read -r line; do
    # trim whitespace & ignore comments
    package=$(echo "$line" | sed -e 's/#.*//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    # add packages that aren't installed
    [[ -n "$package" ]] \
        && ! [[ "$installed" == *"$package"* ]] \
        && packages+=("$package")
done < $dir/brew-packages.conf

count=${#packages[@]}
for (( i=0; i<$count; i++ )); do
    package=${packages[$i]}
    hl_print "installing new package $((i+1))/$count: $package"
    brew_ install $package
done
