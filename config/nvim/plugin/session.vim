" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

" backups
set nobackup
set nowritebackup

" swap
set updatetime=1000           " cursor hold, e.g. write to swap, clear cmd line
set directory=~/.cache/nvim/swap
" create swap dir if it doesn't exist
if !isdirectory($HOME."/.cache/nvim/swap")
  call mkdir($HOME."/.cache/nvim/swap", "p")
endif

" auto-write from @justinmk
augroup AutoWrite
    autocmd!
    " normal & readable buffer, without modifying marks, update (write if
    " changes), `++p` creates directory of file like mkdir -p
    autocmd BufHidden,FocusLost,WinLeave,CursorHold,VimSuspend *
        \ if &buftype == '' && filereadable(expand('%:p')) |
            \ silent lockmarks update ++p |
        \ endif
augroup END
