set runtimepath^=~/.config/nvim runtimepath+=~/.config/nvim/after
let &packpath = &runtimepath
:filetype plugin on
set clipboard=unnamed
set ttimeoutlen=5                " key code delay
set rtp+=/opt/homebrew/opt/fzf   " install fzf
set nomodeline
set switchbuf=usetab
" silent! helptags ALL

