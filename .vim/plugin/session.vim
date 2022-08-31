" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

" save /restore latest session
augroup Stdin
    autocmd!
    autocmd StdinReadPre * let g:read_stdin = 1
augroup END
augroup SaveSession
    autocmd!
    autocmd VimLeave * if !exists('g:read_stdin') | execute 'mksession!' '~/.vim/latest-session.vim' | endif
    autocmd VimEnter * if eval("@%") == "" && !exists('g:read_stdin') | source ~/.vim/latest-session.vim | :colorscheme translucent-dark | edit | endif
augroup END

" backups
set nobackup
set nowritebackup

" swap
set updatetime=300            " swap write & coc hover
set directory=~/.vim/swap//
" create swap dir if it doesn't exist
if !isdirectory($HOME."/.vim/swap")
  call mkdir($HOME."/.vim/swap", "p")
endif

