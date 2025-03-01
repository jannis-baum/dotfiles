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
inoremap <silent> <right> <esc>:call AutoPairsJump()<cr>a
let g:AutoPairsMultilineClose = 0

packadd vim-sneak
let g:sneak#label = 1
nmap m <Plug>Sneak_s
nmap M <Plug>Sneak_S

packadd fugitive

packadd vim-commentary
packadd quick-scope

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

packadd copilot.vim
let g:copilot_filetypes = {
    \'markdown': v:false,
    \'text': v:false
\}
