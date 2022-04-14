noremap <C-o> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-p': 'split',
  \ 'ctrl-v': 'vsplit' }
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p50%,50%' }
else
    let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.5 } }
endif
