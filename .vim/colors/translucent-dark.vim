" test colors: `:so $VIMRUNTIME/syntax/hitest.vim`

highlight clear
if exists("syntax_on")
  syntax reset
endif
set background=dark

" syntax
hi Comment      term=none cterm=italic ctermfg=246 ctermbg=none " gray
hi Constant     term=none cterm=none ctermfg=211 ctermbg=none " light red
hi Special      term=none cterm=none ctermfg=188 ctermbg=none " pale purple
hi Identifier   term=bold cterm=none ctermfg=183 ctermbg=none " bright purple
hi Statement    term=none cterm=none ctermfg=153 ctermbg=none " bright blue
hi PreProc      term=none cterm=none ctermfg=153 ctermbg=none " bright blue
hi Type         term=none cterm=none ctermfg=147 ctermbg=none " darker blue
hi Underlined   term=none cterm=underline ctermfg=153 ctermbg=none " bright blue
hi Ignore       term=none cterm=none ctermfg=248 ctermbg=none " gray
" ui
hi SignColumn   ctermbg=none ctermfg=252
hi StatusLine   ctermbg=240 ctermfg=235
hi StatusLineNC ctermbg=240 ctermfg=235
hi FoldColumn   ctermbg=none ctermfg=none
hi Folded       cterm=italic ctermbg=none ctermfg=240
hi VertSplit    cterm=bold ctermbg=none ctermfg=235
hi LineNr       ctermbg=none ctermfg=240
hi EndOfBuffer  ctermfg=240
hi Pmenu        ctermbg=223  ctermfg=240
hi PmenuSel     ctermbg=240  ctermfg=223
hi PmenuSbar    ctermbg=223  ctermfg=240
hi PmenuThumb   ctermbg=240  ctermfg=223
" diff
hi DiffAdd      ctermbg=235
hi DiffChange   ctermbg=235
hi DiffDelete   ctermbg=235
hi DiffText     ctermbg=235
