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
" repeat f/t/m to go to next match
let g:sneak#s_next = 1
nnoremap m <Plug>Sneak_s
nnoremap M <Plug>Sneak_S
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T

" co-pilot
let g:copilot_filetypes = {
    \'markdown': v:false,
    \'text': v:false
\}
