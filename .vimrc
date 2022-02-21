" ----------------------------------------------------------------------------------------------------------------
" general
" ----------------------------------------------------------------------------------------------------------------
:filetype plugin on
set wildmenu
set mouse=a
set visualbell      " bell
set t_vb=           " .
set scrolloff=8     " extra lines while scrolling
set clipboard=unnamed

" open file at last pos
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
\| exe "normal! g'\"" | endif


" ----------------------------------------------------------------------------------------------------------------
" ui
" ----------------------------------------------------------------------------------------------------------------
set number rnu                        " line numbers
:highlight LineNr ctermfg=8           " .
set nuw=6                             " .
:highlight NonText ctermfg=8          " .
set splitbelow                        " splits
set splitright                        " .
hi StatusLine ctermbg=3 ctermfg=8     " .
hi StatusLineNC ctermbg=7 ctermfg=8   " .
hi VertSplit ctermbg=8 ctermfg=8
syntax on                             " other
set cmdheight=2                       " .
set noshowmode                        " .
set showcmd                           " .
set signcolumn=yes                    " sign column (left)
hi signcolumn ctermbg=None ctermfg=8  " .


" ----------------------------------------------------------------------------------------------------------------
" text
" ----------------------------------------------------------------------------------------------------------------
set incsearch                 " search     
set hlsearch                  " .
set ignorecase                " .
set smartcase                 " .
set tabstop=4 softtabstop=4   " tabs
set shiftwidth=4 smarttab     " .
set expandtab                 " .   
filetype indent on            " .
set autoindent                " .
set smartindent               " .
set wrap                      " text wrapping
set linebreak                 " .


" ----------------------------------------------------------------------------------------------------------------
" keybindings
" ----------------------------------------------------------------------------------------------------------------

" normal and visual
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
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

" save latest session on exit
fu! SaveSession()
    execute 'mksession! ~/.vim/latest-session.vim'
endfunction
autocmd VimLeave * call SaveSession()
" source latest session if invoked without arguments
autocmd VimEnter * if eval("@%") == "" | source ~/.vim/latest-session.vim | edit | endif

" shows syntax data below cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" ----------------------------------------------------------------------------------------------------------------
" backups
" ----------------------------------------------------------------------------------------------------------------
set backup
set writebackup
set backupdir=$HOME/.vim/backup//
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,/var/folders

" create backup dir if it doesn't exist
if !isdirectory($HOME."~/.vim/backup")
  call mkdir($HOME."/.vim/backup", "p")
endif



" ----------------------------------------------------------------------------------------------------------------
" swap
" ----------------------------------------------------------------------------------------------------------------
set swapfile
set directory=~/.vim/swap//

" create swap dir if it doesn't exist
if !isdirectory($HOME."/.vim/swap")
  call mkdir($HOME."/.vim/swap", "p")
endif


" ----------------------------------------------------------------------------------------------------------------
" markdown
" ----------------------------------------------------------------------------------------------------------------
let g:mkdp_browser = 'Safari'
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = expand('~/.vim/markdown-preview/markdown.css')
autocmd BufReadPost *.md call mkdp#util#install()
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
let g:pandoc#syntax#conceal#use = 0


" ----------------------------------------------------------------------------------------------------------------
" ultisnips
" ----------------------------------------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = '<C-s>'
let g:UltiSnipsJumpForwardTrigger = '<C-s>'
let g:UltiSnipsJumpBackwardTrigger = '<C-n>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips']


" ----------------------------------------------------------------------------------------------------------------
" ucompleteme
" ----------------------------------------------------------------------------------------------------------------
" let g:ycm_key_list_stop_completion = '<C-y>'
" let g:ycm_key_invoke_completion = '<C-Space>'
highlight YcmErrorSection ctermbg=None



" --- cterm-colors ---
"
"  0   black
"  1   dark red
"  2   dark green
"  3   dark yellow
"  4   dark blue
"  5   dark magenta
"  6   dark cyan
"  7   light gray
"  8   dark gray
"  9   light red
"  10  light green
"  11  light yellow
"  12  light blue
"  13  light magenta
"  14  light cyan
"  15  light white


" Put these lines at the very end of your vimrc file.
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
