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

" parse #hex-colors in file
function! s:ParseColors()
    exec expand('vert terminal parse-colors %')
endfunction
command! ParseColors call s:ParseColors()
