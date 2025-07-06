" OPTIONS -------------------------------------------------------------
" colors
set notermguicolors             " 256 instead of true color for chameleon hacks
colorscheme jellyfish           " scheme is generated; see .lib/nosync/color-schemes
" status/bottom bar
set noshowmode                  " don't show "Insert"/"Visual" in status bar
set noruler                     " don't show line/col in status bar
" ui elements
set signcolumn=yes              " sign column (left)
set fillchars+=eob:·            " end of buffer filler character
set winborder=solid             " window border
set wildmenu                    " menu
" other
set mouse=a                     " enable mouse
set visualbell                  " terminal bell
set t_vb=                       " .
set scrolloff=8                 " extra lines while scrolling
set splitbelow                  " splits
set splitright                  " .
" set experimental cmdheight=0 on VimEnter because otherwise we get some weird
" "press enter" prompt on startup
augroup SetCmdHeight
    autocmd!
    autocmd VimEnter * set cmdheight=0
augroup END

" TERMINAL CONTROL CHARS ----------------------------------------------
" cursor style
let &t_SI = "\e[5 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"
" kitty underlines
let &t_Ce = "\e[4:0m"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
" underline color
let &t_AU = "\e[58;5;%dm"

" STATUS AND TAB LINE -------------------------------------------------
function! s:modified_marker(buf)
    return getbufinfo(a:buf)[0].changed ? ' ✻' : ''
endfunction

function! s:win_is_editor(winnr)
    return win_gettype(a:winnr) == ''
endfunction

" status line
function! s:lsp_statusline()
    let l:diagnostics = luaeval('vim.diagnostic.get(0)')
    if empty(l:diagnostics) | return '' | endif

    let l:errors = 0
    let l:warnings = 0
    let l:infos = 0
    for l:diag in l:diagnostics
        if l:diag['severity'] == 1
            let l:errors += 1
        elseif l:diag['severity'] == 2
            let l:warnings += 1
        elseif l:diag['severity'] > 2
            let l:infos += 1
        endif
    endfor

    let l:msgs = []
    if l:errors > 0
      call add(l:msgs, '× ' . l:errors)
    endif
    if l:warnings > 0
      call add(l:msgs, '• ' . l:warnings)
    endif
    if l:infos > 0
      call add(l:msgs, '◦ ' . l:infos)
    endif
    if empty(l:msgs) | return '' | endif
    return join(l:msgs, ' | ') . ' | '
endfunction

function! SLContent()
    let l:right = ' ' . s:lsp_statusline() . @% . s:modified_marker('%') . ' '
    let l:spacer_width = winwidth(0) - strwidth(l:right)
    " check if there is any horizontal splitting, then we need the separator
    " char in the bottom
    let l:has_horizontal = stridx(string(winlayout(tabpagenr())), 'col') != -1
    let l:spacer = repeat(l:has_horizontal ? '─' : ' ', l:spacer_width)
    return l:spacer . l:right
endfunction

set statusline=%{SLContent()}
set laststatus=2

" tab line
function! s:tl_label(n)
    let l:bufname = bufname(tabpagebuflist(a:n)[0])
    return l:bufname . s:modified_marker(l:bufname)
endfunction

function! TLContent()
    let l:right = ''
    let l:spacer_width = &columns
    let l:tabnr = tabpagenr('$')
    for i in range(l:tabnr)
        let l:right ..= i + 1 == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        " set the tab page number (for mouse clicks)
        let l:right ..= '%' .. (i + 1) .. 'T'
        " set label
        let l:label = ' ' . s:tl_label(i + 1) . ' '
        let l:spacer_width -= strwidth(l:label) + 1
        let l:right ..= label . '%#TabLine#' . (i < l:tabnr - 1 ? '│' : ' ')
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let l:right ..= '%#TabLineFill#%T'
    let l:spacer = repeat('─', l:spacer_width)
    return '%#TabLine#' . l:spacer . l:right
endfunction

set tabline=%!TLContent()
