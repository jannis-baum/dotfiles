packadd coc

packadd vivify.vim
let g:pandoc#syntax#conceal#use = 0
packadd pandoc-syntax

packadd ultisnips
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

packadd auto-pairs
augroup AutoPairs
    autocmd!
    autocmd Filetype markdown let b:AutoPairs = {"(": ")"}
augroup END
inoremap <right> <esc>:call AutoPairsJump()<cr>a

packadd fugitive

packadd vim-commentary

packadd slime
let g:slime_target = "vimterminal"
let g:slime_vimterminal_config = {
    \"term_finish": "close",
    \"vertical": 1
\}
augroup SlimeTerm
    autocmd!
    autocmd BufEnter * if &buftype == "terminal" | call feedkeys("\<C-W>N") | endif
    autocmd BufLeave * if &buftype == "terminal" | silent! normal i | endif
augroup END

packadd dart-vim-plugin
