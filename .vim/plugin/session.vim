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
set backup
set writebackup
set backupdir=$HOME/.vim/backup//
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,/var/folders
" create backup dir if it doesn't exist
if !isdirectory($HOME."~/.vim/backup")
  call mkdir($HOME."/.vim/backup", "p")
endif

" swap
set directory=~/.vim/swap//
" create swap dir if it doesn't exist
if !isdirectory($HOME."/.vim/swap")
  call mkdir($HOME."/.vim/swap", "p")
endif

