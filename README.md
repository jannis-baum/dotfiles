# My personal config

Here is where I try to keep all configuration of all the tools I use. This is
not intended to be used by anyone else in its entirety, but is nice to look at
for reference.

## [:sparkles: Reusable parts :sparkles:](https://github.com/stars/jannis-baum/lists/my-dotfiles)

I try to keep all parts of my dotfiles that I think may be useful for others in
their own repositories that you can find in [my dotfiles
list](https://github.com/stars/jannis-baum/lists/my-dotfiles)! If you want to
use them, I recommend keeping them as git submodules in your own dotfiles. This
is easy if you use my tool
[`sdf`](https://github.com/jannis-baum/sync-dotfiles.zsh) to manage your
dotfiles.

## Most important tools

- [kitty](https://sw.kovidgoyal.net/kitty/) terminal & as a `tmux`-replacement
  for working locally with much better performance. See
    **[config/kitty/](config/kitty)**.
- [zsh](https://www.zsh.org) as a shell. See **[config/zsh/](config/zsh)**.
- [nvim](https://neovim.io) as an editor. See **[config/nvim/](config/nvim)**.
- [fzf](https://github.com/junegunn/fzf) with
  [fd](https://github.com/sharkdp/fd),
  [ripgrep](https://github.com/BurntSushi/ripgrep) &
  [bat](https://github.com/sharkdp/bat) for file management & fuzzy finding. See
  **[my fzf dotfiles](https://github.com/jannis-baum/fzf-dotfiles)**.
- [git](https://git-scm.com) and GitHub for version control. See **[my git
  dotfiles](https://github.com/jannis-baum/git.zsh-dotfiles.git)**.
- [Karabiner Elements](https://karabiner-elements.pqrs.org) with
  [karabiner.ts](https://github.com/evan-liu/karabiner.ts) to remap my keyboard.
  See **[keymaps.ts](lib/karabiner-config/src/keymap.ts)** for the easily
  readable definitions and to get a rough idea of how I use my five column aka
  "tiny" [Corne keyboard](https://github.com/foostan/crkbd).
- [kindaVim](https://kindavim.app) for vi-bindings **everywhere** in macOS
- [Wooshy](https://wooshy.app) so I (almost) never need to use a mouse

## Full setup

**Disclaimer** If you are not me, you should never do this!

To set up everything (set MacOS preferences, install Homebrew, brew packages &
dotfiles/config), run

```zsh
zsh <(curl -s https://raw.githubusercontent.com/jannis-baum/dotfiles/main/lib/setup/full-setup.sh)
```
