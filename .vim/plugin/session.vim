" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

augroup Suspension
    autocmd!
    " execute commands after resuming from suspension
    autocmd VimResume,VimEnter * if filereadable($SIVIM_RESUME_SOURCE)
            \| execute('source ' . $SIVIM_RESUME_SOURCE)
            \| call delete($SIVIM_RESUME_SOURCE)
        \| endif
    " set modified marker if not all files were saved
    autocmd VimSuspend * if !empty($SIVIM_MARK_MODIFIED)
            \| if getbufinfo({  'buflisted': 1 })->filter({ _, buf -> buf.changed })->len() > 0
                \| call writefile([''], $SIVIM_MARK_MODIFIED)
            \| else
                \| call delete($SIVIM_MARK_MODIFIED)
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

