" GENERAL ----------------------------------------------------------------------
" leader
map <space> <leader>
" fix vim randomly starting in R mode
nnoremap <esc>^[ <esc>^[
" close all with ZZ, one with ZX, suspend with ctrl-u
nnoremap <S-z><S-z> :bufdo bw<CR>:sus<CR>
nnoremap <S-z><S-x> :bw<CR>
nnoremap <C-u> :sus<CR>
" tab navigation
nnoremap <leader>, gT
nnoremap <leader>. gt
" write buffer
nnoremap <leader>w :write<CR>
" remove search highlight
nnoremap <Esc> :noh<CR>

" MOVEMENT ---------------------------------------------------------------------
" line up/down
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" splits
nnoremap <Down> <C-w><C-j>
nnoremap <Up> <C-w><C-k>
nnoremap <Right> <C-w><C-l>
nnoremap <Left> <C-w><C-h>
" scrolling
nnoremap <silent> <C-f> :execute 'normal! ' winheight(0) / 3 . 'j'<CR>
nnoremap <silent> <C-b> :execute 'normal! ' winheight(0) / 3 . 'k'<CR>

" TEXT EDITING -----------------------------------------------------------------
" x & s delete without copy
noremap x "_x
noremap s "_s
" Y consitent with C & D
noremap <S-y> y$
" add undo step for ctrl-u (delete text typed in current line) & ctrl-w
" (delete word before cursor)
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" forward delete (e.g. to undo auto-pair)
inoremap <left> <esc>ls

" SPECIAL CHARACTERS -----------------------------------------------------------
"   spanish tildes
lnoremap <F1> <Nop>
lnoremap <F1>n ñ
lnoremap <F1><S-n> Ñ
lnoremap <F1><S-a> <C-k><S-a>'
lnoremap <F1>a <C-k>a'
lnoremap <F1><S-a> <C-k><S-a>'
lnoremap <F1>e <C-k>e'
lnoremap <F1><S-e> <C-k><S-e>'
lnoremap <F1>i <C-k>i'
lnoremap <F1><S-i> <C-k><S-i>'
lnoremap <F1>u <C-k>u'
lnoremap <F1><S-u> <C-k><S-u>'
lnoremap <F1>o <C-k>o'
lnoremap <F1><S-o> <C-k><S-o>'
"   german umlauts
lnoremap <F2> <Nop>
lnoremap <F2>s <C-k>ss
lnoremap <F2>a <C-k>a<S-:>
lnoremap <F2><S-a> <C-k><S-a><S-:>
lnoremap <F2>u <C-k>u<S-:>
lnoremap <F2><S-u> <C-k><S-u><S-:>
lnoremap <F2>o <C-k>o<S-:>
lnoremap <F2><S-o> <C-k><S-o><S-:>

" MISC -------------------------------------------------------------------------
" shows syntax data below cursor
map <leader>hl :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
