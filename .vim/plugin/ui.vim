set wildmenu                  " menu
set mouse=a                   " mouse
set visualbell                " bell
set t_vb=                     " .
set scrolloff=8               " extra lines while scrolling
syntax on                     " colors
colorscheme translucent-dark  " .
" set number rnu                " line numbers
set nuw=6                     " .
set splitbelow                " splits
set splitright                " .
set noshowmode                " other
set showcmd                   " .
set signcolumn=yes            " sign column (left)
let &fillchars ..= ',eob:·'   " end of buffer filler character
let &fillchars ..= ',vert:│'  " vertical separator

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
    let l:right = ' ' . s:coc_statusline() . @% . ' '
    let l:spacer_width = winwidth(0) - strwidth(l:right)
    let l:spacer = repeat(tabpagewinnr(tabpagenr(), '$') > 1 ? '―' : ' ', l:spacer_width)
    return l:spacer . l:right
endfunction

set statusline=%{SLContent()}
set laststatus=2

" clear message area / command text
augroup ClearMessageArea
    autocmd!
    autocmd CursorHold * echo ''
augroup END
