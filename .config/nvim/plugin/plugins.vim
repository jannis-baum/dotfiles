packadd treesitter

packadd coc

packadd vivify.vim

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

packadd dart-vim-plugin

packadd copilot.vim
let g:copilot_filetypes = {
    \'markdown': v:false,
    \'text': v:false
\}
