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

function trm() {
    if [[ "$#" = 0 ]]; then
        open ~/.Trash
        return 0
    fi
    trash $@
}

# eject disks
function ej() {
    while true; do
        local disk="$(ls /Volumes | grep LaCie | head -1)"
        [[ -z "$disk" ]] && break
        diskutil eject "$disk"
    done
}

# reload color schemes
function rcols() {
    make -C ~/_/dev/dotfiles/lib/color-schemes load
    source $HOME/.zshenv
    source $ZDOTDIR/.zshrc
    _si_vim_cmd ReloadConfig
}

# clone repo in clones dir & cd there
function gclo() {
    [[ "$#" != "1" ]] && echo "Repo URL required" && return 1
    cd ~/_/dev/clones || return 1
    git clone --recursive "$1"
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

# new python executable
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

function gif-from-video() {
    if ! test -f "$1" || [[ "$1" != *.* ]]; then
        echo "usage: gif-from-video video.extension [frame-rate]" >&2
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

function gif-from-images() {
    if [[ $# -lt 3 ]]; then
        echo "usage: gif-from-images name.gif time_per_image image1 [image2 ...]" >&2
        return 1
    fi

    local output="$1"
    local time_per_image="$2"
    shift 2

    for input in "$@"; do
        if ! test -f "$input"; then
            echo "file \"$input\" doesn't exist" >&2
            return 1
        fi
    done

    local temp_dir="$(mktemp --directory)"
    local frames_file="$temp_dir/frames.txt"
    for input in "$@"; do
        echo "file '$(realpath "$input")'" >> "$frames_file"
        echo "duration $time_per_image" >> "$frames_file"
    done

    local palette_file="$temp_dir/palette.png"
    ffmpeg -f concat -safe 0 -i "$frames_file" -vf palettegen "$palette_file"

    ffmpeg -f concat -safe 0 -i "$frames_file" -i "$palette_file" -lavfi "fps=30 [x]; [x][1:v] paletteuse" -loop 0 "$output"
}

function cop() {
    local tmp_dir="$(mktemp --directory)"
    [[ $# -gt 0 ]] && cp $@ "$tmp_dir"
    cd "$tmp_dir"
    copilot
    cd -1
    rm -r "$tmp_dir"
}
