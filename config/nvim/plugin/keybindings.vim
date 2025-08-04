" GENERAL ----------------------------------------------------------------------
" leader
map <space> <leader>
" close/suspend depending on si_vim
if exists('$SIVIM_RESUME_SOURCE')
    " write all, close all and suspend with <leader>z 
    nnoremap <leader>z <cmd>wa \| bufdo bw \| suspend<cr>
    " close this buffer with <leader>x
    nnoremap <leader>x <cmd>bw<cr>
    " suspend with ctrl-u
    nnoremap <c-u> <cmd>suspend<cr>
else
    " si_vim same but with closing instead of suspending
    nnoremap <leader>z <cmd>wqa<cr>
    nnoremap <leader>x <cmd>q<cr>
    nnoremap <c-u> <cmd>wqa<cr>
endif
" tab navigation
nnoremap <leader>, gT
nnoremap <leader>. gt
" write buffer
nnoremap <leader>w <cmd>write<cr>
" remove search highlight
nnoremap <esc> <cmd>noh<cr>

" MOVEMENT ---------------------------------------------------------------------
" line up/down
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" beg/end
noremap M ^
noremap m $
" splits
nnoremap <down> <c-w><c-j>
nnoremap <up> <c-w><c-k>
nnoremap <right> <c-w><c-l>
nnoremap <left> <c-w><c-h>
" scrolling
nnoremap <silent> <c-f> <cmd>execute 'normal! ' winheight(0) / 3 . 'j'<cr>
nnoremap <silent> <c-b> <cmd>execute 'normal! ' winheight(0) / 3 . 'k'<cr>
" free z for sneak
nnoremap , z

" TEXT EDITING -----------------------------------------------------------------
" x & s delete without copy
noremap x "_x
noremap s "_s
" Y consitent with C & D
noremap Y y$
" add undo step for ctrl-u (delete text typed in current line) & ctrl-w
" (delete word before cursor)
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" forward delete (e.g. to undo auto-pair)
inoremap <left> <esc>ls

" MORE COMPLEX MAPPINGS --------------------------------------------------------
" <bs> to extract text object into variable
noremap <silent> <bs> <cmd>call <sid>setupChangeVar()<cr>c

function! s:setupChangeVar()
  augroup ChangeVarHandler
    autocmd!
    autocmd InsertLeave * ++once call <sid>changeVarModifyRegister()
  augroup END
endfunction

function! s:changeVarModifyRegister()
  let l:inserted_text = getreg('.')
  let l:changed_text = getreg('+')
  call setreg('+', l:inserted_text . ' = ' . l:changed_text)
endfunction

" SPECIAL CHARACTERS -----------------------------------------------------------
"   spanish tildes
lnoremap <f1> <Nop>
lnoremap <f1>n ñ
lnoremap <f1>N Ñ
lnoremap <f1>A <c-k>A'
lnoremap <f1>a <c-k>a'
lnoremap <f1>A <c-k>A'
lnoremap <f1>e <c-k>e'
lnoremap <f1>E <c-k>E'
lnoremap <f1>i <c-k>i'
lnoremap <f1>I <c-k>I'
lnoremap <f1>u <c-k>u'
lnoremap <f1>U <c-k>U'
lnoremap <f1>o <c-k>o'
lnoremap <f1>O <c-k>O'
"   german umlauts
lnoremap <f2> <Nop>
lnoremap <f2>s <c-k>ss
lnoremap <f2>a <c-k>a<s-:>
lnoremap <f2>A <c-k>A<s-:>
lnoremap <f2>u <c-k>u<s-:>
lnoremap <f2>U <c-k>U<s-:>
lnoremap <f2>o <c-k>o<s-:>
lnoremap <f2>O <c-k>O<s-:>

" MISC -------------------------------------------------------------------------
" shows syntax data below cursor
map <leader>hl :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
