# todo

## kitty

- set up tmux replacement
  - popover & fzf-tmux alternative? -> [not possible right
    now](https://github.com/kovidgoyal/kitty/discussions/4018)
- proper color setup:
  - define color env vars in kitty
  - use them for kitty, vim, bat, etc

## vim

- fzf
  - switch to open buffer
- plugin to comment code, e.g. [this
  one](https://github.com/tomtom/tcomment_vim)
- make vim save state per directory instead of globally

## shell

- fzf hotkeys:
  - switch between git-ls and fd
  - toggle bat preview (default disabled)
- fix regex in rgi

## scripts

### sync-dotfiles

- find a way to have vim packs in dotfiles repo without too many copies
- ignore file & additional commands for syncs (e.g. `goku` for `karabiner.edn`)

### icloud-backup

- copies given file(s) from `~/...` to parallel directory `~/Library/Mobile\
  Documents/com\~apple\~CloudDocs/...`
- created directory if not there yet
- (gives info on how much space icloud files are using and how much i have left
  in plan?)
- (give option to zip)

## other

- [yabai window manager](https://github.com/koekeishiya/yabai)
- [hotkey daemon](https://github.com/koekeishiya/skhd)
