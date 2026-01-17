" open files at last position from `:h restore-cursor`
" (not for commit messages, interactive rebase, etc.)
augroup RestoreCursor
    autocmd!
    autocmd BufReadPre * autocmd FileType <buffer> ++once
      \ let s:line = line("'\"")
     \| if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit' && index(['xxd', 'gitrebase'], &filetype) == -1
     \|     execute "normal! g`\""
     \| endif
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
