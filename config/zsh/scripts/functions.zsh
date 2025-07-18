# generate new password
function passn() {
	echo | pbcopy
	while [[ $(pbpaste) =~ '^[^0-9]*$' || $(pbpaste) =~ '^[^a-z]*$' || $(pbpaste) =~ '^[^A-Z]*$' ]]; do
        cat /dev/urandom \
            | LC_ALL=C tr -dc 'a-zA-Z0-9-_\$,.!?:;~`^+=@&%#*[](){}/' \
            | fold -w 32 \
            | head -1 \
            | tr -d '\n' \
            | pbcopy
	done
}
# quick look
function ql() {
    if ! test -e "$1"; then
        echo "\"$1\": No such file or directory"
        return 1
    fi
    qlmanage -p "$1" >& /dev/null
}

# reload color schemes
function rcols() {
    make -C ~/_/dev/dotfiles/lib/color-schemes load
    source $ZDOTDIR/.zshrc
    _si_vim_isrunning && _si_vim_cmd ReloadConfig
}
# clone repo in clones dir & cd there
function gclo() {
    [[ "$#" != "1" ]] && echo "Repo URL required" && return 1
    cd ~/_/dev/clones || return 1
    git clone "$1"
    cd $(basename "$_" .git)
}

# rmarkdown
# 1 arg: knit $1 to temporary file & open
# 2 args: knit to $2
function rmd() {
    if ! test -f "$1"; then
        echo "File required" >&2
        return 1
    fi

    local f="$(realpath "$1")"
    [[ -z "$2" ]] && local out="$(mktemp).html" || local out="$2"

    R -e "library(rmarkdown); render('$f', output_file = '$out')"
    [[ -z "$2" ]] && open "$out"
}

function pynew() {
    if test -e "$1"; then
        echo "File exists" >&2
        return 1
    fi
    mkdir -p "$(dirname "$1")"
    cat <<EOF > "$1"
#!/usr/bin/env python3

import argparse


def main(args):
    pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    args = parser.parse_args()
    main(args)
EOF
    chmod +x "$1"
    $EDITOR "$1"
}

# apple photos orders photos by the file modification datetime at import...
# so photos exported by lightroom are always messed up when imported into apple
# photos because the modification (export) datetime is not the capture datetime.
# this function takes the datetime defined in lightroom/exif data and sets the
# modification date to that for all JPGs in the directory.
function fix-photo-timstamps() {
    for file in *.jpg; do
        capture_date=$(exiftool -DateTimeOriginal -d "%Y%m%d%H%M.%S" "$file" | cut -d: -f2- | tr -d ' ')
        touch -t "$capture_date" "$file"
    done
}

function make-gif() {
    if ! test -f "$1" || [[ "$1" != *.* ]]; then
        echo "usage: make-gif video.extension [frame-rate]" >&2
        return 1
    fi

    local input="$1"
    local name="$(rev <<<"$input" | cut -d. -f2- | rev)"
    local ext="$(rev <<<"$input" | cut -d. -f1  | rev)"
    local temp="$name.temp.gif"
    local output="$name.gif"

    local framerate="$2"
    [[ -z "$framerate" ]] && framerate=15

    if test -f "$temp" || test -f "$output"; then
        echo "file \"$temp\" or \"$output\" already exists" >&2
        return 1
    fi

    ffmpeg \
        -i "$input" \
        -vf "fps=$framerate,scale=1000:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        -loop 0 "$temp"

    gifsicle \
        --optimize=3 \
        --threads=$(sysctl -n hw.ncpu) \
        "$temp" \
        -o "$output"

    rm "$temp"

    echo "Done! File sizes:"
    echo "- original: $(du -sh "$input")"
    echo "- GIF: $(du -sh "$output")"
}
