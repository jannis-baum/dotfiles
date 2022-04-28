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
        if l:file =~ ' s\(p\(lit\)\?\)\?$'
            let l:cmd = 'split'
        elseif l:file =~ ' v\(ert\(ical\)\?\)\?\( \?s\(p\(lit\)\?\)\?\)\?$'
            let l:cmd = 'vsplit'
        else
            let l:cmd = 'edit'
        endif
        call system('mkdir -p ' . fnamemodify(l:dirname . l:file, ':h'))
        execute l:cmd l:dirname . l:file
    endif
endfunction

let g:fzf_action = {
  \ 'ctrl-p': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-n': function('s:new_file') }
