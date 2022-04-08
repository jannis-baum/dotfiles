setlocal spell

call mkdp#util#install()
let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = expand('~/.vim/markdown-preview/markdown.css')

" do stuff between $$
nnoremap da$ F$df$
nnoremap di$ T$dt$
nnoremap ya$ F$yf$
nnoremap yi$ T$yt$
nnoremap ca$ F$cf$
nnoremap ci$ T$ct$

