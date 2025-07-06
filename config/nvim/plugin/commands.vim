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
    if exists('b:has_vsp_empty')
        return
    endif

    function! s:VspEmptySetFillchar(option, value)
        " remove existing entry for the given option
        let l:parts = filter(split(&fillchars, ','), 'v:val !~ "^' . a:option . ':"')
        let &l:fillchars = join(l:parts, ',')
        " escape value if it's a space
        let l:escaped_value = a:value ==# ' ' ? '\ ' : a:value
        " append the new option
        execute 'setlocal fillchars+=' . a:option . ':' . l:escaped_value
    endfunction

    function! s:VspEmptyNewsplit(orig_win, cols)
        " create new split with empty buffer
        vnew
        exec 'vertical resize ' .. a:cols
        " locally disable fillchar EOB, vert & status line
        call s:VspEmptySetFillchar('vert', ' ')
        call s:VspEmptySetFillchar('eob', ' ')
        setlocal statusline=\ 
        " autocmd to automatically delete empty buffer when leaving original
        let l:on_leave = 'autocmd BufLeave <buffer> ++once exec "bdelete ' .. bufnr() .. '"'
        " go back & register autocmd
        call win_gotoid(a:orig_win)
        return l:on_leave
    endfunction

    " get current win ID and options
    let l:win = win_getid()
    let l:orig_splitright = &splitright
    let l:restore_fillchars = 'autocmd BufLeave <buffer> ++once let &l:fillchars="' .. &l:fillchars .. '"'
    " disable nvim-focus/focus.nvim
    let l:orig_focus = exists('g:focus_disable') ? g:focus_disable : v:false

    " how big the spacer splits are
    let l:spacer_cols = &columns / 6

    " open splits & set options
    let g:focus_disable = v:true
    let l:close_first = s:VspEmptyNewsplit(l:win, l:spacer_cols)
    let &l:splitright = !l:orig_splitright
    let l:close_second = s:VspEmptyNewsplit(l:win, l:spacer_cols)
    let g:focus_disable = l:orig_focus
    let &l:splitright = l:orig_splitright
    call s:VspEmptySetFillchar('vert', ' ')

    " cleanup after leaving buffer
    exec l:close_first
    exec l:close_second
    exec l:restore_fillchars
    autocmd BufLeave <buffer> ++once unlet b:has_vsp_empty
    let b:has_vsp_empty = 1
endfunction
command! VspEmpty call s:VspEmpty()
nnoremap <silent> <leader>v :VspEmpty<CR>

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
