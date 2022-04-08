" leader
map <space> <leader>
" normal and visual
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap gj j
vnoremap gj j
nnoremap gk k
vnoremap gk k
nnoremap x "_x
vnoremap x "_x
" normal
nnoremap <Esc> :noh<CR>
nnoremap <S-y> y$
nnoremap <C-p> "*p
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
" to fix vim randomly starting in R mode
nnoremap <esc>^[ <esc>^[
" close all with ZZ
nnoremap <S-z><S-z> :wqa<CR>
" insert
"   inoremap jk <Esc>  " handled by karabiner
"   inoremap kj <Esc>  " handled by karabiner
"   spanish tildes
inoremap <F1> <Nop>
inoremap <F1>n ñ
inoremap <F1><S-n> Ñ
inoremap <F1><S-a> <C-k><S-a>'
inoremap <F1>a <C-k>a'
inoremap <F1><S-a> <C-k><S-a>'
inoremap <F1>e <C-k>e'
inoremap <F1><S-e> <C-k><S-e>'
inoremap <F1>i <C-k>i'
inoremap <F1><S-i> <C-k><S-i>'
inoremap <F1>u <C-k>u'
inoremap <F1><S-u> <C-k><S-u>'
inoremap <F1>o <C-k>o'
inoremap <F1><S-o> <C-k><S-o>'
"   german umlauts
inoremap <F2> <Nop>
inoremap <F2>s <C-k>ss
inoremap <F2>a <C-k>a<S-:>
inoremap <F2><S-a> <C-k><S-a><S-:>
inoremap <F2>u <C-k>u<S-:>
inoremap <F2><S-u> <C-k><S-u><S-:>
inoremap <F2>o <C-k>o<S-:>
inoremap <F2><S-o> <C-k><S-o><S-:>

" visual
vnoremap <C-c> "*y
vnoremap <C-x> "*d
vnoremap <C-p> d"*<S-p>

" markdown delete / yank / change in $$
autocmd BufNewFile,BufRead *.md nnoremap da$ F$df$
autocmd BufNewFile,BufRead *.md nnoremap di$ T$dt$
autocmd BufNewFile,BufRead *.md nnoremap ya$ F$yf$
autocmd BufNewFile,BufRead *.md nnoremap yi$ T$yt$
autocmd BufNewFile,BufRead *.md nnoremap ca$ F$cf$
autocmd BufNewFile,BufRead *.md nnoremap ci$ T$ct$

" :WE to :w :e
command! -nargs=1 -complete=file WE write | edit <args>

" shows syntax data below cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

