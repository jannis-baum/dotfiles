" highlight the symbol and its references when holding the cursor
if !exists('g:omit_coc')
    augroup Coc
        autocmd!
        autocmd CursorHold * silent call CocActionAsync('highlight')
    augroup END
endif

" EXTENSIONS ---
let g:coc_global_extensions = [
    \'coc-sh',
    \'coc-pyright',
    \'coc-clangd', 'coc-cmake',
    \'coc-sourcekit',
    \'coc-tsserver', 'coc-tslint-plugin', 'coc-eslint', 
    \'coc-flutter',
    \'coc-html', 'coc-css', '@yaegassy/coc-tailwindcss3', 'coc-json',
    \'coc-git', 'coc-docker',
    \'coc-markdownlint'
\]

" BINDINGS ---
" use tab for completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" return for confirmation (e.g. auto import)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" ctrl-space to bring up completion
inoremap <silent><expr> <c-@> coc#refresh()

" gd / gr - go to definition of word / type under cursor
nmap <silent> gdd <Plug>(coc-definition)
nmap <silent> gdv :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gdp :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gyy <Plug>(coc-type-definition)
nmap <silent> gyv :call CocAction('jumpTypeDefinition', 'vsplit')<CR>
nmap <silent> gyv :call CocAction('jumpTypeDefinition', 'split')<CR>

" gr - find references
nmap <silent> gr <Plug>(coc-references)

" gh - get hint on whatever's under the cursor
nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)

" view all errors
nnoremap <silent> <leader>cl  :<C-u>CocList diagnostics<CR>

" select command
nnoremap <silent> <leader>cc :<C-u>CocList commands<CR>

