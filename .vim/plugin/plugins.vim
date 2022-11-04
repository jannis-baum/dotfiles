if !exists('g:omit_coc')
    packadd coc
endif

packadd markdown-preview.nvim
packadd pandoc-syntax

packadd ultisnips
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

packadd fugitive
packadd auto-pairs
augroup AutoPairs
    autocmd!
    autocmd Filetype markdown let b:AutoPairs = {"(": ")"}
augroup END

packadd slime
packadd dart-vim-plugin
