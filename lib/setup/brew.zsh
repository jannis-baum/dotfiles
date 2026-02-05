#!/bin/zsh

function hl_print() {
    printf "\\033[1m$1\\033[0m\n"
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

hl_print "checking installed packages"
installed=$(brew leaves && brew list --cask | sed 's/^/--cask /')
packages=()
while IFS= read -r line; do
    # trim whitespace & ignore comments
    package=$(echo "$line" | sed -e 's/#.*//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    # add packages that aren't installed (ignore --HEAD flag)
    [[ -n "$package" ]] \
        && ! [[ "$installed" == *"$(sed 's/--HEAD //' <<<"$package")"* ]] \
        && packages+=("$package")
done < "$(dirname $(realpath $0))/brew-packages.conf"

count=$#packages
for (( i = 1; i <= $count; i++ )); do
    package=$packages[i]
    hl_print "installing new package $i/$count: $package"
    brew_ install ${=package}
done

hl_print "running brew cleanup"
brew_ cleanup
