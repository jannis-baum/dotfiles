# My personal config

Here is where I try to keep all configuration of all the tools I use. This is
not intended to be used by anyone else in its entirety, but might be nice to
look at for reference.

## Installing/syncing dotfiles

[`sdf`](.zsh/scripts/sdf.zsh) is my script (zsh function) that I use to
synchronize/install my dotfiles based on its own config file [.sdfrc](.sdfrc).
See the comment in [sdf.zsh](.zsh/scripts/sdf.zsh) for more information on how
to use it and what it does.

## Most important development tools

- [kitty](https://sw.kovidgoyal.net/kitty/) terminal & as a `tmux`-replacement
  for working locally with much better performance. See
    **[.config/kitty/](.config/kitty)**.
- [zsh](https://www.zsh.org) as a shell. See **[.zsh/](.zsh)** and
  **[.zshenv](.zshenv)**.
- [vim](https://www.vim.org) as an editor with
  [CoC](https://github.com/neoclide/coc.nvim) for powerful completion & language
  support. See **[.vim/](.vim)**.
- [fzf](https://github.com/junegunn/fzf) with
  [fd](https://github.com/sharkdp/fd),
  [ripgrep](https://github.com/BurntSushi/ripgrep) &
  [bat](https://github.com/sharkdp/bat) for file management & fuzzy finding. See
  **[fzf.zsh](.zsh/scripts/fzf.zsh)** and
  **[fzf.vim](.vim/after/plugin/fzf.vim)**.
- [git](https://git-scm.com) and GitHub for version control. See my
  **[git zsh functions](.zsh/scripts/git)**.
- [Karabiner Elements](https://karabiner-elements.pqrs.org) with
  [goku](https://github.com/yqrashawn/GokuRakuJoudo) to remap my keyboard. See
  **[karabiner.edn](.config/karabiner.edn)** for the definitions and **[my
  visualized keyboard layers](docs.nosync/keyboard-layers.md)** to get a rough
  idea of how I use my five column aka "tiny" [Corne
  keyboard](https://github.com/foostan/crkbd).

## Tools that help with macOS

- [kindaVim](https://kindavim.app) for amazing vi-bindings **everywhere**
- [Wooshy](https://wooshy.app) so I (almost) never need to use a mouse

## Full setup

**Disclaimer** If you are not me, you should probably never do this!

To set up everything (set MacOS preferences, install Homebrew, brew packages &
dotfiles/config), make sure you have `git`, `zsh` and `bash` installed and run

```zsh
zsh <(curl -s https://raw.githubusercontent.com/jannis-baum/dotfiles/main/setup.nosync/full-setup.sh)
```
