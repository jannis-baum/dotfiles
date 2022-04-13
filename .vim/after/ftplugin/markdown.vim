" setup
setlocal spell
set textwidth=80
set tabstop=2 softtabstop=2
set shiftwidth=2

" plugins
call mkdp#util#install()
let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = expand('~/.vim/markdown-preview/markdown.css')

let g:pandoc#syntax#conceal#use = 0

" do stuff between $$
nnoremap da$ F$df$
nnoremap di$ T$dt$
nnoremap ya$ F$yf$
nnoremap yi$ T$yt$
nnoremap ca$ F$cf$
nnoremap ci$ T$ct$

