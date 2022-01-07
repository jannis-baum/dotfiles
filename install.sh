#!/bin/sh

for f in `find home -type f`; do
    inst=$(echo $f | sed 's/home/~/')
    if [ "$f" -nt "$inst" ]; then
        printf '%s\n' "$inst"
        cp "$f" $inst
    fi
done

