" COC
if !exists('g:omit_coc')
    packadd coc
endif

" MARKDOWN ---
packadd markdown-preview.nvim
packadd pandoc-syntax

" ULTISNIPS ---
packadd ultisnips
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" FUGITIVE ---
packadd fugitive

" SLIME ---
packadd slime

