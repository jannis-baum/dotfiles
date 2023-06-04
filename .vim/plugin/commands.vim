function! s:Split(file)
    if (winheight(0) * 2 > winwidth(0))
        execute 'split ' . a:file
    else
        execute 'vsplit ' . a:file
    endif
endfunction
command! -nargs=? -complete=file SPLIT call s:Split(<q-args>)

" function to open file from si_vim (see .zsh/scripts/si_vim.zsh)
function! s:SivOpen(file)
    " we check if the file is open anywhere and switch to its buffer
    " this works well with `set switchbuf=usetab`
    for buf in getbufinfo({ 'bufloaded': 1 })
        if buf.name =~ a:file
            execute 'sbuffer ' . buf.bufnr
            return
        endif
    endfor

    " if the buffer is empty, e.g. when we just opened vim without a file, we
    " edit the file in the current buffer
    if (expand('%:p') == '')
        execute 'edit ' . a:file
    else
        " else we open the file in a new tab
        execute 'tabedit ' . a:file
    endif
    " fix some problem with ft detection
    filetype detect
endfunction
command! -nargs=1 -complete=file SivOpen call s:SivOpen(<q-args>)

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
