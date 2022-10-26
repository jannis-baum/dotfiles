ibkp() {
    local backup_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/ibkp"
    mkdir -p $backup_dir

    for arg in "$@"; do
        case "$arg" in
            "-p" | "--print-directory") local should_print=1; continue;;
            "-t" | "--tree-size") local should_tree=1; continue;;
            "-s" | "--size") local should_size=1; continue;;
            "-d" | "--cd") local should_cd=1; continue;;
            "-h" | "--help") local should_help=1; continue;;
        esac

        local dir_name=$(dirname $arg)
        local source_dir=$(realpath $dir_name)
        if [[ "$source_dir" != "$HOME"* ]]; then
            echo "\e[2m\e[3m$arg not in home directory, skipping\e[0m"
            continue
        fi

        if [[ -n "$should_size" ]]; then
            du -sh $arg
        fi

        local dest_dir=$(sed "s|$HOME|$backup_dir|" <<< "$source_dir")
        local file_name=$(sed "s|$dir_name||" <<< "$arg")
        mkdir -p "$dest_dir"
        cp -r "$arg" "$dest_dir/$file_name"
    done

    [[ -n "$should_print" ]] && echo $backup_dir
    [[ -n "$should_tree" ]] && \
        exa --long --no-user --no-permissions --no-time \
            --tree --all --group-directories-first \
            --ignore-glob='.git|node_modules|.DS_Store' \
            $backup_dir
    [[ -n "$should_size" ]] && du -sh $backup_dir | sed -r "s|$backup_dir/?|total backups size|"
    [[ -n "$should_cd" ]] && cd $backup_dir
    [[ -n "$should_help" ]] && cat <<EOF
usage: ibkp [-h] [-p] [-t] [-s] [-d] paths [paths ...]

positional arguments:
  paths               file(s) and/or directory/ies to back up

options:
  -h, --help            show this help message and exit
  -p, --print-directory show the backup directory
  -t, --tree-size       show the backup directory's file tree with file sizes
  -s, --size            show the backup directory's total size
  -d, --cd              change the cwd to the backup directory
EOF
}
