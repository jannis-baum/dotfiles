augroup RuffOnWrite
    autocmd!
    autocmd BufWritePost *.py call s:RunRuffFixAndFormat(expand('%:p'))
augroup END

function! s:RunRuffFixAndFormat(filepath) abort
    if !executable('ruff')
        return
    endif
    let l:oldtime = getftime(a:filepath)
    silent! execute '!ruff format ' . shellescape(a:filepath)
    silent! execute '!ruff check --fix ' . shellescape(a:filepath)
    let l:newtime = getftime(a:filepath)
    if l:newtime > l:oldtime
        silent! edit
    endif
endfunction
