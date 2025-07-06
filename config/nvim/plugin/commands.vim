" reload (most of) the config
if !exists('g:reload_config_defined')
    let g:reload_config_defined = 1
    function! s:ReloadConfig()
        for f in glob($HOME . '/.config/nvim/plugin/**/*.vim', 0, 1)
            execute 'source ' . f
        endfor
        for f in glob($HOME . '/.config/nvim/plugin/**/*.lua', 0, 1)
            execute 'luafile ' . f
        endfor
    endfunction
    command! ReloadConfig call s:ReloadConfig()
endif

" open empty vsp to get earlier soft line breaks
function! s:VspEmpty()
    let l:win = win_getid()
    vsp
    enew
    " locally disable fillchar EOB
    let &l:fillchars = join(map(split(&fillchars, ','),
        \{_, v -> v =~# '^eob:' ? 'eob: ' : v}),
    \',')
    call win_gotoid(l:win)
endfunction
command! VspEmpty call s:VspEmpty()

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
    if exists('g:preview_colors_term_bufnr')
        execute 'bw ' . g:preview_colors_term_bufnr
    endif
    let g:preview_colors_term_bufnr = term_start('parse-colors', {
        \ 'vertical': 1,
        \ 'in_io': 'buffer', 'in_buf': g:preview_colors_origin,
        \ 'in_top': line('w0'), 'in_bot': line('w$')
    \ })
    execute 'sbuffer ' . g:preview_colors_origin
endfunction

function! s:PreviewColorsStart()
    augroup PreviewColorsSync
        autocmd!
        let g:preview_colors_origin = bufnr()
        autocmd CursorHold,CursorHoldI * if bufnr() == g:preview_colors_origin | call s:PreviewColors() | endif
    augroup END
endfunction
function! s:PreviewColorsStop()
    augroup PreviewColorsSync
        autocmd!
        unlet g:preview_colors_origin
        unlet g:preview_colors_term_bufnr
    augroup END
endfunction
command! PreviewColorsStart call s:PreviewColorsStart()
command! PreviewColorsStop call s:PreviewColorsStop()

" reload color config
if !exists('g:reload_colors_defined')
    let g:reload_colors_defined = 1
    function! s:ReloadColors()
        call system('make -C ~/_dotfiles/.lib/nosync/color-schemes load')
        ReloadConfig
    endfunction
    command! RCOLS call s:ReloadColors()
endif
