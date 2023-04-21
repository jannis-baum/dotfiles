" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

" execute extra commands after suspension
augroup SusResume
    autocmd!
    autocmd VimResume,VimEnter * if filereadable($RESUME_SOURCE)
            \| execute('source ' . $RESUME_SOURCE)
            \| call delete($RESUME_SOURCE)
        \| endif
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

