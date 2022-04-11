" COC
packadd coc

" MARKDOWN ---
packadd markdown-preview.nvim
packadd pandoc-syntax

" ULTISNIPS ---
autocmd BufNewFile,BufRead *.md packadd ultisnips
let g:UltiSnipsExpandTrigger = '<C-n>'
let g:UltiSnipsJumpForwardTrigger = '<C-n>'
let g:UltiSnipsJumpBackwardTrigger = '<C-m>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" FUGITIVE ---
packadd fugitive

" SLIME ---
packadd slime

