" COC
if !exists('g:omit_coc')
    packadd coc
endif

" MARKDOWN ---
packadd markdown-preview.nvim
packadd pandoc-syntax

" ULTISNIPS ---
packadd ultisnips
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" FUGITIVE ---
packadd fugitive

" SLIME ---
packadd slime

" DART ---
packadd dart-vim-plugin
