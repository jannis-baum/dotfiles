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

" hacky helpers for creating color schemes -------------------------------------
" live preview hex colors in current buffer
function! s:PreviewColors()
    if exists('g:parse_colors_term_bufnr')
        execute 'bw ' . g:parse_colors_term_bufnr
    endif
    let g:parse_colors_term_bufnr = term_start('parse-colors', {
        \ 'vertical': 1,
        \ 'in_io': 'buffer', 'in_buf': g:parse_colors_origin,
        \ 'in_top': line('w0'), 'in_bot': line('w$')
    \ })
    execute 'sbuffer ' . g:parse_colors_origin
endfunction

function! s:PreviewColorsStart()
    augroup PreviewColorsSync
        autocmd!
        let g:parse_colors_origin = bufnr()
        autocmd CursorHold,CursorHoldI * if bufnr() == g:parse_colors_origin | call s:ParseColors() | endif
    augroup END
endfunction
function! s:PreviewColorsStop()
    augroup PreviewColorsSync
        autocmd!
        unlet g:parse_colors_origin
        unlet g:parse_colors_term_bufnr
    augroup END
endfunction
command! PreviewColorsStart call s:PreviewColorsStart()
command! PreviewColorsStop call s:PreviewColorsStop()

" reload color config
function s:ReloadColors()
    call system('make -C ~/_dotfiles/.lib/nosync/color-schemes')
    if $KITTY_PID != ''
        call system('kill -SIGUSR1 ' . $KITTY_PID)
        ReloadConfig
    endif
endfunction
command! RCOLS call s:ReloadColors()
