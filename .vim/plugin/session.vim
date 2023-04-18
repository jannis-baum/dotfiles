" open file at last pos
augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
augroup END

" execute extra commands after suspension
augroup SusResume
    autocmd!
    let s:resume_source = $HOME . '/.vim/resume-source.vim'
    autocmd VimResume * if filereadable(s:resume_source) | execute('source ' . s:resume_source) | call delete(s:resume_source) | endif
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

