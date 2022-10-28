#!/bin/zsh

paths=$(mdfind -0 "((kMDItemDisplayName = \"*\"cdw)\
    && (kMDItemContentTypeTree=com.apple.application)\
    && (kMDItemSupportFileType != \"*\"cdw)\
    && (kMDItemExecutablePlatform!=LSRequiresIPhoneOS))")
names=$(printf "$paths" | xargs -0 mdls -name kMDItemDisplayName -raw)

paste -d ':'\
    <(printf "$names" | tr "\0" "\n")\
    <(printf "$paths" | tr "\0" "\n")
