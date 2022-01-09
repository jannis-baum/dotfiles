#!/bin/sh

dotfiles="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../home"
for f in `find $dotfiles -type f`; do
    inst=$(echo $f | sed "s,$dotfiles,$HOME,")
    if [ "$f" -nt "$inst" ]; then
        printf '%s\n' "$inst"
        cp "$f" "$inst"
    fi
done

