packadd coc

packadd markdown-preview.nvim
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
packadd slime
packadd dart-vim-plugin
