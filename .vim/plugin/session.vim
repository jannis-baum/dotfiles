" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

augroup Suspension
    autocmd!
    " execute commands after resuming from suspension
    autocmd VimResume,VimEnter * if filereadable($RESUME_SOURCE)
            \| execute('source ' . $RESUME_SOURCE)
            \| call delete($RESUME_SOURCE)
        \| endif
    " set modified marker if not all files were saved
    autocmd VimSuspend * if !empty($RESUME_SOURCE)
            \| if getbufinfo({  'buflisted': 1 })->filter({ _, buf -> buf.changed })->len() > 0
                \| call writefile([''], $RESUME_SOURCE . '.modified')
            \| else
                \| call delete($RESUME_SOURCE . '.modified')
            \| endif
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

