" test colors: `:so $VIMRUNTIME/syntax/hitest.vim`

" BOILERPLATE (dark coloschemes) -----------------------------------------------
highlight clear
if exists("syntax_on")
  syntax reset
endif
set background=dark

" DEFINITIONS ------------------------------------------------------------------
" setter
function! s:sethig(group, ...)
    let histring = 'highlight ' . a:group . ' '
    if strlen(a:1)
        let histring .= 'ctermfg=' . a:1 . ' '
    endif
    if a:0 >= 2 && strlen(a:2)
        let histring .= 'cterm=' . a:2 . ' '
    else
        let histring .= 'cterm=none '
    endif
    if a:0 >= 3 && strlen(a:3)
        let histring .= 'ctermbg=' . a:3
    else
        let histring .= 'ctermbg=none'
    endif
    execute histring
endfunction

" colors: dark -> light

" neutrals (gray)
let s:neut1 = 235
let s:neut2 = 238
let s:neut3 = 240
let s:neut4 = 246
let s:neut5 = 248
let s:neut6 = 252

" syntax
" A (red)
let s:synA1 = 211
" B (purple)
let s:synB1 = 183
let s:synB2 = 188
" C (blue)
let s:synC1 = 147
let s:synC2 = 153

" main hightlight (yellow-orange)
let s:main1 = 216
let s:main2 = 223

" COLORSCHEME ------------------------------------------------------------------
" syntax
call s:sethig('Comment',    s:neut4, 'italic')
call s:sethig('Constant',   s:synA1)
call s:sethig('Special',    s:synB2)
call s:sethig('Identifier', s:synB1, 'bold')
call s:sethig('Statement',  s:synC2)
call s:sethig('PreProc',    s:synC2)
call s:sethig('Type',       s:synC1)
call s:sethig('Underlined', s:synC2, 'underline')
call s:sethig('Ignore',     s:neut5)

" ui
call s:sethig('SignColumn',   s:neut6)
call s:sethig('StatusLine',   s:neut3, 'bold')
call s:sethig('StatusLineNC', s:neut2, 'none')
call s:sethig('FoldColumn',   'none')
call s:sethig('Folded',       s:neut3, 'italic')
call s:sethig('VertSplit',    s:neut1, 'bold')
call s:sethig('LineNr',       s:neut3)
call s:sethig('EndOfBuffer',  s:neut3)
call s:sethig('Pmenu',        s:neut3, 'none', s:main2)
call s:sethig('PmenuSel',     s:main2, 'none', s:neut3)
call s:sethig('PmenuSbar',    s:neut3, 'none', s:main2)
call s:sethig('PmenuThumb',   s:main2, 'none', s:neut3)
" diff
call s:sethig('DiffAdd',    '', '', s:neut1)
call s:sethig('DiffChange', '', '', s:neut1)
call s:sethig('DiffDelete', '', '', s:neut1)
call s:sethig('DiffText',   '', '', s:neut1)

