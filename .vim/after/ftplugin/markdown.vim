" setup
setlocal spell
setlocal spelllang=en_us,de
set textwidth=80
set tabstop=2 softtabstop=2
set shiftwidth=2

" plugins
let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = expand($HOME . '/.vim/markdown-preview/markdown.css')

let g:pandoc#syntax#conceal#use = 0

" do stuff between $$
nnoremap da$ F$df$
nnoremap dam F$df$

nnoremap di$ T$dt$
nnoremap dim T$dt$

nnoremap ya$ F$yf$
nnoremap yam F$yf$

nnoremap yi$ T$yt$
nnoremap yim T$yt$

nnoremap ca$ F$cf$
nnoremap cam F$cf$

nnoremap ci$ T$ct$
nnoremap cim T$ct$

" folding
function! GetMarkdownFold(lnum)
    return getline(a:lnum) =~ '^#.*$' ? '0' : '1'
endfunction
setlocal foldmethod=expr
setlocal foldexpr=GetMarkdownFold(v:lnum)
setlocal foldlevel=1
