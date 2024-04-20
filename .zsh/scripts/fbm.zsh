function _fbm_find() {
    (
    while [[ "$(pwd)" != "/" ]]; do
        test -f '.fbms' && cat .fbms
        cd ..
    done
    )
}

function fbm() {
    if [[ "$1" == "-n" || "$1" == "--new" ]]; then
        if [[ "$#" != "3" ]]; then
            echo "usage: fbm [-n | --new] name uri"
            return 1
        fi
        echo "$2\t$3" >> .fbms
    fi
}
