# My personal config

Here is where I try to keep all configuration of all the tools I use. This is
not intended to be used by anyone else in its entirety, but is nice to look at
for reference.

## Reusable parts

I am currently working on extracting all parts of my dotfiles that I think may
be useful for others into their own repositories. If you want to use them, I
recommend keeping them as git submodules in your own dotfiles! This is easy if
you use my tool [`sdf`](https://github.com/jannis-baum/sync-dotfiles.zsh) to
manage your dotfiles.

Below is a list of things I already have & still want to extract into their own
repositories

### Submodules

- [sync-dotfiles.zsh](https://github.com/jannis-baum/sync-dotfiles.zsh): the zsh
  utility function I use to manage my own configuration files as well as all my
  plugins & dependiencies, and automatically reload configs for all tools
- [git.zsh dotfiles](https://github.com/jannis-baum/git.zsh-dotfiles): my zsh
  functions to blaze through git & GitHub workflows
- [si-vim.zsh](https://github.com/jannis-baum/si-vim.zsh): keeps a single
  instance of vim running & attached to each interactive zsh session. This
  enables you to switch back and forth between vim and zsh instantly.
- [cookie-cleaner](https://github.com/jannis-baum/cookie-cleaner): tool to purge
  all non-whitelisted cookies from safari

### To-do

The following are parts of my dotfiles that I will create separate repositories
for soon:

- fzf file & directory management
- ibkp.zsh to back up files in iCloud

## Most important tools

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
- [git](https://git-scm.com) and GitHub for version control. See my **[git zsh
  functions](https://github.com/jannis-baum/git.zsh-dotfiles.git)**.
- [Karabiner Elements](https://karabiner-elements.pqrs.org) with
  [goku](https://github.com/yqrashawn/GokuRakuJoudo) to remap my keyboard. See
  **[karabiner.edn](.config/karabiner.edn)** for the definitions and **[my
  visualized keyboard layers](docs.nosync/keyboard-layers.md)** to get a rough
  idea of how I use my five column aka "tiny" [Corne
  keyboard](https://github.com/foostan/crkbd).
- [kindaVim](https://kindavim.app) for amazing vi-bindings **everywhere**
- [Wooshy](https://wooshy.app) so I (almost) never need to use a mouse

## Full setup

**Disclaimer** If you are not me, you should probably never do this!

To set up everything (set MacOS preferences, install Homebrew, brew packages &
dotfiles/config), make sure you have `git`, `zsh`, `bash`, `make` and `swift`
installed and run

```zsh
zsh <(curl -s https://raw.githubusercontent.com/jannis-baum/dotfiles/main/setup.nosync/full-setup.sh)
```
