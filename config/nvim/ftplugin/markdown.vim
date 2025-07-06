" setup
setlocal spell
setlocal spelllang=en_us,de
setlocal tabstop=2 softtabstop=2
setlocal shiftwidth=2

" do stuff between $$
nnoremap da$ F$df$
nnoremap dam F$df$

nnoremap di$ T$dt$
nnoremap dim T$dt$

nnoremap ya$ F$yf$
nnoremap yam F$yf$

nnoremap yi$ T$yt$
nnoremap yim T$yt$

nnoremap ca$ F$cf$
nnoremap cam F$cf$

nnoremap ci$ T$ct$
nnoremap cim T$ct$

" folding
function! GetMarkdownFold(lnum)
    return getline(a:lnum) =~ '^#.*$' ? '0' : '1'
endfunction
setlocal foldmethod=expr
setlocal foldexpr=GetMarkdownFold(v:lnum)
setlocal foldlevel=1

" open empty vsps to get earlier soft line breaks
function! s:WriteMode()
    if exists('b:has_write_mode')
        return
    endif

    function! s:WriteModeSetFillchar(option, value)
        " remove existing entry for the given option
        let l:parts = filter(split(&fillchars, ','), 'v:val !~ "^' . a:option . ':"')
        let &l:fillchars = join(l:parts, ',')
        " escape value if it's a space
        let l:escaped_value = a:value ==# ' ' ? '\ ' : a:value
        " append the new option
        execute 'setlocal fillchars+=' . a:option . ':' . l:escaped_value
    endfunction

    function! s:WriteModeNewSplit(orig_win, cols)
        " create new split with empty buffer
        vnew
        exec 'vertical resize ' .. a:cols
        " locally disable fillchar EOB, vert & status line
        call s:WriteModeSetFillchar('vert', ' ')
        call s:WriteModeSetFillchar('eob', ' ')
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
    let l:close_first = s:WriteModeNewSplit(l:win, l:spacer_cols)
    let &l:splitright = !l:orig_splitright
    let l:close_second = s:WriteModeNewSplit(l:win, l:spacer_cols)
    let g:focus_disable = l:orig_focus
    let &l:splitright = l:orig_splitright
    call s:WriteModeSetFillchar('vert', ' ')

    " cleanup after leaving buffer
    exec l:close_first
    exec l:close_second
    exec l:restore_fillchars
    autocmd BufLeave <buffer> ++once unlet b:has_write_mode
    let b:has_write_mode = 1
endfunction
command! WriteMode call s:WriteMode()
nnoremap <silent> <leader>v :WriteMode<CR>
