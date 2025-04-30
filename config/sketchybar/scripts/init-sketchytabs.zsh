#!/bin/zsh

# helper to set up icon disk on RAM

# exit if volume is already there
test -d /Volumes/sketchytabs-icons && exit 0

# create ram disk with given number of 512byte blocks (i.e. 256MB)
diskutil erasevolume APFS "sketchytabs-icons" $(hdiutil attach -nomount ram://524288)
