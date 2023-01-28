function! s:Split(file)
    if (winheight(0) * 2 > winwidth(0))
        execute 'split ' . a:file
    else
        execute 'vsplit ' . a:file
    endif
endfunction

command! -nargs=? -complete=file SPLIT call s:Split(<q-args>)
