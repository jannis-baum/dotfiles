" fugitive
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap <leader>gc :bd fugitive://<CR>
nnoremap <leader>gh :diffget //2<CR>
nnoremap <leader>gl :diffget //3<CR>

" ultisnips
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']

" auto-pairs
augroup AutoPairs
    autocmd!
    autocmd Filetype markdown let b:AutoPairs = {"(": ")"}
augroup END
inoremap <silent> <right> <esc>:call AutoPairsJump()<cr>a
let g:AutoPairsMultilineClose = 0

" sneak
let g:sneak#label = 1
nmap m <Plug>Sneak_s
nmap M <Plug>Sneak_S

" co-pilot
let g:copilot_filetypes = {
    \'markdown': v:false,
    \'text': v:false
\}
