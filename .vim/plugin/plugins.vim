" COC
packadd coc

" MARKDOWN ---
packadd markdown-preview.nvim
packadd pandoc-syntax

" ULTISNIPS ---
autocmd BufNewFile,BufRead *.md packadd ultisnips
let g:UltiSnipsExpandTrigger = '<C-s>'
let g:UltiSnipsJumpForwardTrigger = '<C-s>'
let g:UltiSnipsJumpBackwardTrigger = '<C-n>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips']

