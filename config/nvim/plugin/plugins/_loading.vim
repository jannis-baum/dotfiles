packadd vivify.vim
packadd jupyviv.nvim
packadd highlight2ansi.nvim

for f in glob($HOME . '/.config/zv/**/*.vim', 0, 1)
    execute 'source ' . f
endfor
