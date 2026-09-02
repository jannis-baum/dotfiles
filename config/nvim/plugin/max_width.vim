" open empty vsps to limit max width, e.g. for wider monitors
function! s:MaxWMode()
    let l:ideal_width = 160
    if exists('g:disable_maxw_mode') || l:ideal_width >= &columns
        return
    endif

    function! s:MaxWModeSetFillchar(option, value)
        " remove existing entry for the given option
        let l:parts = filter(split(&fillchars, ','), 'v:val !~ "^' . a:option . ':"')
        let &l:fillchars = join(l:parts, ',')
        " escape value if it's a space
        let l:escaped_value = a:value ==# ' ' ? '\ ' : a:value
        " append the new option
        execute 'setlocal fillchars+=' . a:option . ':' . l:escaped_value
    endfunction

    function! s:MaxWModeNewSplit(orig_win, cols)
        " create new split with empty buffer
        vnew
        exec 'vertical resize ' .. a:cols
        " locally disable fillchar EOB, vert & status line
        call s:MaxWModeSetFillchar('vert', ' ')
        call s:MaxWModeSetFillchar('eob', ' ')
        setlocal statusline=\ 
        let b:is_maxw_mode = 1
        " autocmd to automatically delete empty buffer when leaving original
        let l:cleanup = 'exec "bdelete ' .. bufnr() .. '"'
        " go back & register autocmd
        call win_gotoid(a:orig_win)
        return l:cleanup
    endfunction

    " get current win ID and options
    let l:win = win_getid()
    let l:orig_splitright = &splitright
    let l:cleanup = ['let &l:fillchars="' .. &l:fillchars .. '"']
    " disable nvim-focus/focus.nvim
    let l:orig_focus = exists('g:focus_disable') ? g:focus_disable : v:false

    " how big the spacer splits are
    let l:spacer_cols = (&columns - l:ideal_width) / 2

    " open splits & set options
    let g:focus_disable = v:true
    let l:cleanup += [s:MaxWModeNewSplit(l:win, l:spacer_cols)]
    let &l:splitright = !l:orig_splitright
    let l:cleanup += [s:MaxWModeNewSplit(l:win, l:spacer_cols)]
    let g:focus_disable = l:orig_focus
    let &l:splitright = l:orig_splitright
    call s:MaxWModeSetFillchar('vert', ' ')

    let b:is_maxw_mode = 1

    " cleanup after leaving buffer
    let l:cleanup += ["unlet g:disable_maxw_mode", "call setbufvar(" . bufnr() . ", 'is_maxw_mode', 0)"]
    let g:disable_maxw_mode = join(l:cleanup, " | ")
    exec 'autocmd BufWinLeave <buffer> ++once if exists("g:disable_maxw_mode") | exec g:disable_maxw_mode | endif'
endfunction

function! s:AutoMaxWMode(timer)
    if (exists('b:is_maxw_mode') && b:is_maxw_mode == 1) || win_gettype() ==# 'popup'
        return
    endif
    if winnr('$') != 1
        if exists('g:disable_maxw_mode')
            silent! exec g:disable_maxw_mode
        endif
        return
    endif
    call  s:MaxWMode()
endfunction

augroup AutoMaxWMode
    autocmd!
    " have to use timer to run this when back in main event loop (with delay
    " 0), otherwise vim complains it can't open splits while closing another
    " window
    autocmd BufEnter,VimEnter,VimResume * call timer_start(0, 's:AutoMaxWMode')
augroup END
