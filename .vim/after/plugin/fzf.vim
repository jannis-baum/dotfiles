" find files -------------------------------------------------------------------

noremap <C-o> :FZF<CR>

if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p50%,50%' }
else
    let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.5 } }
endif

function! s:new_file(lines) abort
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

function! s:file_action(lines) abort
    let l:cmd = input('{' . a:lines[0] . '}: ')
    if len(l:cmd) > 0
        let l:out = system(substitute(l:cmd, '{}', a:lines[0], ''))
        echo substitute(l:out, '\n', '', '')
    endif
endfunction

let g:fzf_action = {
    \'ctrl-p': 'split',
    \'ctrl-v': 'vsplit',
    \'ctrl-n': function('s:new_file'),
    \'ctrl-o': function('s:file_action')
\}


" dynamic ripgrep --------------------------------------------------------------

function! s:rgi_select(lines) abort
    let l:key = a:lines[0]

    let l:fields = split(a:lines[1], ':')
    let l:query = l:fields[0][1:-2]
    let l:file = l:fields[1]
    let l:line = l:fields[2]
    let l:column = l:fields[3]

    if key == 'ctrl-p'
        let l:cmd = 'split'
    elseif key == 'ctrl-v'
        let l:cmd = 'vsplit'
    else
        let l:cmd = 'edit'
    endif

    execute l:cmd l:file
    call cursor(l:line, l:column)
    normal zz
    let @/ = l:query
endfunction

let s:rg_command = 'rg --column --line-number --no-heading'
function! s:rgi() abort
    call fzf#run(fzf#wrap({
        \'source': [],
        \'options': [
            \'--delimiter', ':',
            \'--with-nth', '2',
            \'--no-multi',
            \'--bind', 'change:reload:' . s:rg_command . ' {q} | sed "s/^/{q}:/g" || true',
            \'--disabled',
            \'--preview-window', 'right,70%,wrap,border-left',
            \'--preview', 'bat --style=numbers --color=always --line-range={3}: {2} 2>/dev/null ' .
                \'| rg --color always --context 10 {q}',
            \'--expect', 'ctrl-p,ctrl-v'
        \],
        \'sink*': function('s:rgi_select')
    \}))
endfunction

command! RGI let @/ = '' | call s:rgi() | set hlsearch

" buffers ----------------------------------------------------------------------

function! s:buffers_list()
    let l:cwd = getcwd() . '/'
    return getbufinfo({ 'buflisted': 1 })
        \->map({ _, buf -> buf['bufnr'] . ':' . buf['name']->substitute(l:cwd, '', '') })
endfunction

function! s:buffers_select(line)
    let l:bufnr = a:line->substitute(':.*$', '', '')
    execute 'buffer' l:bufnr
endfunction

function! s:fzf_buffers() abort
    call fzf#run(fzf#wrap({
        \'source': s:buffers_list(),
        \'options': [
            \'--delimiter', ':',
            \'--with-nth', '2',
            \'--no-multi',
            \'--preview-window', 'right,70%,border-left',
            \'--preview', 'bat --style=numbers --color=always {2} 2>/dev/null',
        \],
        \'sink': function('s:buffers_select')
    \}))
endfunction

command! BUF call s:fzf_buffers()
