noremap <C-o> :FZF<CR>

if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p50%,50%' }
else
    let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.5 } }
endif

function! s:new_file(lines)
    let l:dirname = fnamemodify(a:lines[0], ':h') . '/'
    let l:file = input('new file: ' . l:dirname)
    if len(l:file) > 0
        call system('mkdir -p ' . fnamemodify(l:dirname . l:file, ':h'))
        execute 'edit' l:dirname . l:file
    endif
endfunction

let g:fzf_action = {
  \ 'ctrl-p': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-n': function('s:new_file') }

