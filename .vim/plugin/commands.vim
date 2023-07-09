function! s:Split(file)
    if (winheight(0) * 2 > winwidth(0))
        execute 'split ' . a:file
    else
        execute 'vsplit ' . a:file
    endif
endfunction
command! -nargs=? -complete=file SPLIT call s:Split(<q-args>)

" reload (most of) the config
if !exists('g:reload_config_defined')
    let g:reload_config_defined = 1
    function! s:ReloadConfig()
        for f in glob($HOME . '/.vim/plugin/**/*.vim', 0, 1) + glob($HOME . '/.vim/after/plugin/**/*.vim', 0, 1)
            execute 'source ' . f
        endfor
    endfunction
    command! ReloadConfig call s:ReloadConfig()
endif

" close all but current buffer
function! s:CloseOthers()
    let l:thisbuf = bufnr()
    for buf in getbufinfo({ 'bufloaded': 1 })
        if buf.bufnr != l:thisbuf
            execute 'bw ' . buf.bufnr
        endif
    endfor
endfunction
command! BC call s:CloseOthers()
