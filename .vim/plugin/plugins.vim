packadd coc

let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 1
let g:mkdp_markdown_css = expand($HOME . '/.vim/markdown-preview/markdown.css')
packadd markdown-preview.nvim

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
packadd slime
packadd dart-vim-plugin
