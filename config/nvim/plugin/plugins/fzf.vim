let g:fzf_layout = { 'window': {
    \'width': 0.8, 'height': 0.6,
    \'border': 'none'
\} }
let g:fzf_colors = {
    \ 'bg': ['bg', 'NormalFloat'],
    \ 'bg+': ['bg', 'NormalFloat'],
    \ 'gutter': ['bg', 'NormalFloat'],
\}

let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS . ' --preview-window=border-left --prompt="» "'

nnoremap <silent> <tab> :BUF<cr>
