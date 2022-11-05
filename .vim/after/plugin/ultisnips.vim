" see `help UltiSnips-trigger-functions`
let g:ulti_expand_or_jump_res = 0 "default value, just set once
function! s:ulti_expandorjump()
    call UltiSnips#ExpandSnippetOrJump()
    return g:ulti_expand_or_jump_res
endfunction

" see `help UltiSnips-trigger-functions`
imap <silent><tab> <C-R>=(<SID>ulti_expandorjump() > 0) ? "" : "\<tab>" <CR>
