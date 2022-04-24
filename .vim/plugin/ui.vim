set wildmenu                  " menu
set mouse=a                   " mouse
set visualbell                " bell
set t_vb=                     " .
set scrolloff=8               " extra lines while scrolling
syntax on                     " colors
colorscheme translucent-dark  " .
set number rnu                " line numbers
set nuw=6                     " .
set splitbelow                " splits
set splitright                " .
set noshowmode                " other
set showcmd                   " .
set signcolumn=yes            " sign column (left)
let &fillchars ..= ',eob: '   " end of buffer filler character
let &fillchars ..= ',vert:│'  " vertical separator

" cursor style
let &t_SI = "\e[5 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"
" kitty undercurls
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" status line
function SLContent()
    let l:left = @% . ' '
    let l:spacer_width = winwidth(0) - len(l:left)
    let l:spacer = repeat('―', l:spacer_width)
    return l:left . l:spacer
endfunction
set statusline=%{SLContent()}

