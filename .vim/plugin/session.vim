" open file at last pos
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
\| exe "normal! g'\"" | endif

" save latest session on exit
fu! SaveSession()
    execute 'mksession! ~/.vim/latest-session.vim'
endfunction
autocmd VimLeave * call SaveSession()
" source latest session if invoked without arguments
autocmd VimEnter * if eval("@%") == "" | source ~/.vim/latest-session.vim | :colorscheme translucent-dark | edit | endif

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

