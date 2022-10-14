ibkp() {
    local backup_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/ibkp"
    mkdir -p $backup_dir

    for arg in "$@"; do
        if [[ "$arg" == "-d" || "$arg" == "--cd" ]] then;
            local should_cd=1
            continue
        fi

        local dir_name=$(dirname $arg)
        local source_dir=$(realpath $dir_name)
        if [[ "$source_dir" != "$HOME"* ]]; then
            echo "\e[2m\e[3m$arg not in home directory, skipping\e[0m"
            continue
        fi
        local dest_dir=$(sed "s|$HOME|$backup_dir|" <<< "$source_dir")
        local file_name=$(sed "s|$dir_name||" <<< "$arg")
        mkdir -p "$dest_dir"
        cp -r "$arg" "$dest_dir$file_name"
    done

    [[ -n "$should_cd" ]] && cd $backup_dir
}
