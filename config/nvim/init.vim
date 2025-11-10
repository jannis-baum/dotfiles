set runtimepath^=~/.config/nvim
let &packpath = &runtimepath

" load plugins
" zv
for f in glob($HOME . '/.config/zv/**/*.vim', 0, 1)
    execute 'source ' . f
endfor
" runtimepath adjustments have to happen in init.vim
set runtimepath+=~/.local/lib/masipalavi/nvim
set runtimepath+=/opt/homebrew/opt/fzf
" own plugins kept in /pack/plugins/opt/ for developability
packadd vivify.vim
packadd jupyviv.nvim
packadd highlight2ansi.nvim
