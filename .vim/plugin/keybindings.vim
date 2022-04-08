" GENERAL ----------------------------------------------------------------------
" leader
map <space> <leader>
" fix vim randomly starting in R mode
nnoremap <esc>^[ <esc>^[
" close all with ZZ
nnoremap <S-z><S-z> :wqa<CR>
" remove search highlight
nnoremap <Esc> :noh<CR>

" MOVEMENT ---------------------------------------------------------------------
" line up/down
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap gj j
vnoremap gj j
nnoremap gk k
vnoremap gk k
" splits
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" TEXT EDITING -----------------------------------------------------------------
" x & s delete without copy
nnoremap x "_x
nnoremap s "_s
vnoremap x "_x
vnoremap s "_s
" Y consitent with C & D
nnoremap <S-y> y$

" SPECIAL CHARACTERS -----------------------------------------------------------
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

" MISC -------------------------------------------------------------------------
" shows syntax data below cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

