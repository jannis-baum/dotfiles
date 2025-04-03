augroup AutoPairs
    autocmd!
    autocmd Filetype markdown let b:AutoPairs = {"(": ")"}
augroup END

inoremap <silent> <right> <esc>:call AutoPairsJump()<cr>a

let g:AutoPairsMultilineClose = 0
