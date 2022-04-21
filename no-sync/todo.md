# todo

## kitty

- setup popover window
  - try hiding with swift script

```swift
import AppKit

AXUIElementSetAttributeValue(AXUIElementCreateApplication(<kitty-pid>),
kAXHiddenAttribute as CFString, kCFBooleanTrue)
```

- set up tmux replacement
  - [keyboard
    shortcuts](https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts), make
    prefix (*multi-key shortcut*) like in tmux
  - generic keybindings such as tabs/panes, reloading config, etc
  - status line
  - popover & fzf-tmux alternative?

## vim

- set up fzf+rg inside of vim
- plugin to comment code, e.g. [this
  one](https://github.com/tomtom/tcomment_vim)
- make vim save state per directory instead of globally

## shell

- bat colors

## other

- [yabai window manager](https://github.com/koekeishiya/yabai)
- [hotkey daemon](https://github.com/koekeishiya/skhd)
