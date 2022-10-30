#!/bin/zsh

module_dir=$(dirname $(realpath $0))

paths=$(mdfind -0 "((kMDItemDisplayName = \"*\"cdw)\
    && (kMDItemContentTypeTree=com.apple.application)\
    && (kMDItemSupportFileType != \"*\"cdw)\
    && (kMDItemExecutablePlatform!=LSRequiresIPhoneOS))")

names=$(printf "$paths" | xargs -0 mdls -name kMDItemDisplayName -raw)

paste -d ':'\
    <(printf "$names" | tr "\0" "\n")\
    <(printf "$paths" | tr "\0" "\n")\
| jq --raw-input --null-input --compact-output \
    '[ inputs | split(":") | { "title": .[0], "fileIconFilePath": .[1], "userInfo" : .[1] } ]' \
> "$module_dir/source.json"
