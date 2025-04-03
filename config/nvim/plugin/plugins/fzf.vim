let g:fzf_layout = { 'window': {
    \'width': 0.8, 'height': 0.6,
    \'yoffset': 0,
    \'border': 'sharp',
\} }

let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS . ' --preview-window=border-left'

nnoremap <silent> <tab> :BUF<cr>
