" COC
packadd coc

" MARKDOWN ---
autocmd BufReadPre *.md packadd markdown-preview.nvim
autocmd BufNewFile,BufRead *.md packadd pandoc-syntax
autocmd BufReadPost *.md call mkdp#util#install()
let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = expand('~/.vim/markdown-preview/markdown.css')
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
let g:pandoc#syntax#conceal#use = 0

" ULTISNIPS ---
autocmd BufNewFile,BufRead *.md packadd ultisnips
let g:UltiSnipsExpandTrigger = '<C-s>'
let g:UltiSnipsJumpForwardTrigger = '<C-s>'
let g:UltiSnipsJumpBackwardTrigger = '<C-n>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips']

