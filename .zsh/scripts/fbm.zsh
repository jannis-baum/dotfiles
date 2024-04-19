function _fbm_find() {
    (
    while [[ "$(pwd)" != "/" ]]; do
        test -f '.fbms' && cat .fbms
        cd ..
    done
    )
}
