" jump coc if has target, else jump ultisnips if has target, else insert tab
"
" see `help UltiSnips-trigger-functions`
let g:ulti_expand_or_jump_res = 0 "default value, just set once
function! s:ulti_expandorjump()
    call UltiSnips#ExpandSnippetOrJump()
    return g:ulti_expand_or_jump_res
endfunction

function! s:coc_expandorjump()
    if coc#expandableOrJumpable()
        call coc#snippet#next()
        return 1
    endif
    return 0
endfunction

" see `help UltiSnips-trigger-functions`
imap <silent><tab> <C-R>=(<SID>coc_expandorjump() > 0) ? "" : (<SID>ulti_expandorjump() > 0) ? "" : "\<tab>"<CR>
