set wildmenu                    " menu
set mouse=a                     " mouse
set visualbell                  " bell
set t_vb=                       " .
set scrolloff=8                 " extra lines while scrolling
syntax on                       " colors
colorscheme translucent-dynamic " .
" set number rnu                " line numbers
set nuw=6                       " .
set splitbelow                  " splits
set splitright                  " .
set noshowmode                  " other
set showcmd                     " .
set signcolumn=yes              " sign column (left)
let &fillchars ..= ',eob:·'     " end of buffer filler character
let &fillchars ..= ',vert:│'    " vertical separator

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

" status & tab line
function! s:modified_marker(buf)
    return getbufinfo(a:buf)[0].changed ? ' ✻' : ''
endfunction

" status line
function! s:coc_statusline()
    let l:info = get(b:, 'coc_diagnostic_info', {})
    if empty(l:info) | return '' | endif

    let l:msgs = []
    if get(l:info, 'error', 0)
      call add(l:msgs, '❌ ' . l:info['error'])
    endif
    if get(l:info, 'warning', 0)
      call add(l:msgs, '⚠️  ' . l:info['warning'])
    endif
    if empty(l:msgs) | return '' | endif
    return join(l:msgs, ' | ') . ' | '
endfunction

function! SLContent()
    let l:right = ' ' . s:coc_statusline() . @% . s:modified_marker('%') . ' '
    let l:spacer_width = winwidth(0) - strwidth(l:right)
    let l:spacer = repeat(tabpagewinnr(tabpagenr(), '$') > 1 ? '―' : ' ', l:spacer_width)
    return l:spacer . l:right
endfunction

set statusline=%{SLContent()}
set laststatus=2

" tab line
function! s:tl_label(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufname = bufname(buflist[l:winnr - 1])
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
    let l:spacer = repeat('―', l:spacer_width)
    return '%#TabLine#' . l:spacer . l:right
endfunction

set tabline=%!TLContent()

" clear message area / command text
augroup ClearMessageArea
    autocmd!
    autocmd CursorHold * echo ''
augroup END
