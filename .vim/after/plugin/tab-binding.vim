" insert mode tab binding in this order:
" - if ultisnips can expand snippet, expand
" - if ultisnips can jump forward, jump forward
" - if pum is visible, select down
" - if cursor is at column 0 or preceded by space, insert tab
" - bring up coc-completion pum

" see `help UltiSnips-trigger-functions`
let g:ulti_expand_or_jump_res = 0 "default value, just set once
function! s:ulti_expandorjump()
    call UltiSnips#ExpandSnippetOrJump()
    return g:ulti_expand_or_jump_res
endfunction

function! s:coc_tab()
    if coc#pum#visible()
        call coc#pum#next(1)
        return ''
    endif

    let col = col('.') - 1
    if !col || getline('.')[col - 1]  =~# '\s'
        return "\<tab>"
    endif

    call coc#refresh()
    return ''
endfunction

" see `help UltiSnips-trigger-functions`
imap <silent><tab> <C-R>=(<SID>ulti_expandorjump() > 0) ? "" : <SID>coc_tab() <CR>
