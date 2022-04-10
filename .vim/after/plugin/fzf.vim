noremap <C-o> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-p': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.5 } }
