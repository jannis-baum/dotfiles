" AUTOCMDS ---
augroup Coc
    autocmd!
    " highlight the symbol and its references when holding the cursor
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " format on save in dart files
    autocmd BufWritePost *.dart silent call CocAction('format')
augroup END

" EXTENSIONS ---
let g:coc_global_extensions = [
    \'coc-snippets',
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
" completion scrolling
iunmap <down>
inoremap <expr><down> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
iunmap <up>
inoremap <expr><Up> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" snippets
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_next = '<s-tab>'
" return for confirmation (e.g. auto import)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
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
