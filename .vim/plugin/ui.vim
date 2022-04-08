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
set cmdheight=2               " other
set noshowmode                " .
set showcmd                   " .
set signcolumn=yes            " sign column (left)
let &fillchars ..= ',eob: '   " end of buffer filler character
let &fillchars ..= ',vert:│'  " vertical separator

" cursor style
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

