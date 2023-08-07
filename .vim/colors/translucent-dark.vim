" test colors: `:so $VIMRUNTIME/syntax/hitest.vim`

" BOILERPLATE (dark coloschemes) -----------------------------------------------
highlight clear
if exists("syntax_on")
    syntax reset
endif
set background=dark

" DEFINITIONS ------------------------------------------------------------------
" setter: group, foreground, deco, background, underline color
function! s:HI(group, ...)
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
        let histring .= 'ctermbg=' . a:3 . ' '
    else
        let histring .= 'ctermbg=none'
    endif
    if a:0 >= 4 && strlen(a:4)
        let histring .= 'ctermul=' .a:4
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
" A (pink)
let s:synA1 = 175
" B (purple)
let s:synB1 = 183
let s:synB2 = 182
" C (blue)
let s:synC1 = 147
let s:synC2 = 153
" errors & warnings
let s:syner = 203
let s:swarn = 214

" main hightlight (pale yellow)
let s:main1 = 229

" blues: 105, 111
" cyan: 123

" COLORSCHEME ------------------------------------------------------------------
" syntax
call s:HI('Comment',    s:neut4, 'italic')
call s:HI('Constant',   s:synA1)
call s:HI('Special',    s:synB2)
call s:HI('Identifier', s:synB1, 'bold')
call s:HI('Statement',  s:synC2)
hi! link Preproc Statement
call s:HI('Type',       s:synC1)
call s:HI('Underlined', s:synC2, 'underline')
call s:HI('Ignore',     s:neut5)
call s:HI('Todo',       s:neut4, 'bold')
call s:HI('MatchParen', s:neut1, 'none', s:main1)

" spell & errors
call s:HI('Error', 'none', 'undercurl', 'none', s:syner)
hi! link SpellCap Error 
hi! link SpellRare Error
hi! link SpellLocal Error
hi! link SpellBad Error 
hi! link CocErrorHighlight Error
call s:HI('CocWarningHighlight', 'none', 'undercurl', 'none', s:swarn)
hi! link CocUnusedHighlight CocWarningHighlight
call s:HI('CocInfoHighlight', 'none', 'undercurl', 'none', s:synC1)
hi! link CocHintHightlight CocInfoHighlight
call s:HI('ErrorMsg', s:syner)

" ui
call s:HI('SignColumn',   s:neut6)
call s:HI('StatusLine',   s:neut3, 'bold')
hi! link StatusLineTerm StatusLine
call s:HI('StatusLineNC', s:neut2, 'none')
hi! link StatusLineTermNC  StatusLineNC
call s:HI('FoldColumn',   'none')
call s:HI('Folded',       s:neut3, 'italic')
call s:HI('VertSplit',    s:neut1, 'bold')
call s:HI('LineNr',       s:neut3)
hi! link EndOfBuffer LineNr
call s:HI('TabLineFill', s:neut3, 'none', 'none')
call s:HI('TabLine', s:neut3, 'none', 'none')
call s:HI('TabLineSel', s:synB1, 'bold', 'none')

" diff
call s:HI('DiffAdd',    '', '', s:neut1)
hi! link DiffChange DiffAdd 
hi! link DiffDelete DiffAdd 
hi! link DiffText DiffAdd 

" misc
call s:HI('Search', s:neut1, 'none', s:main1)
call s:HI('CocHighlightText', 'none', 'underline', 'none', s:neut6)
call s:HI('Sneak', s:neut1, 'none', s:synB1)
call s:HI('SneakLabel', s:neut1, 'bold', s:synB1)
