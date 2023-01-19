let g:fzf_layout = { 'window': {
    \'width': 0.8, 'height': 0.6,
    \'yoffset': 0,
    \'border': 'sharp',
\} }

let s:sink_by_key = {
    \'ctrl-o': 'vsplit',
    \'ctrl-u': 'split',
    \'': 'edit'
\}

" find files -------------------------------------------------------------------

command! FZFIND call s:fzf_finder()
noremap <silent><C-o> :FZFIND<CR>

let s:finder_ls = substitute(
    \ system('source $ZDOTDIR/scripts/directories.zsh'
        \ . " && which l | sed 's/^l: aliased to //'"),
    \ '\n', '', '')
let s:finder_fd_cmd = "fd --color=always --hidden --follow --strip-cwd-prefix"
function! s:fzf_finder() abort
    call fzf#run(fzf#wrap({
        \'source': split(system(s:finder_fd_cmd), '\n'),
        \'options': [
            \'--ansi',
            \'--expect=ctrl-o,ctrl-u,ctrl-n,ctrl-v',
            \'--no-multi',
            \'--preview-window=right,60%,border-left,nohidden',
            \'--preview', 'test -d {} ' .
                \'&& source $HOME/.zshenv && ' . s:finder_ls . ' {} ' .
                \'|| bat --style=numbers --color=always {}',
            \'--bind=left:reload(' . s:finder_fd_cmd . ' --no-ignore)'
        \],
        \'sink*': function('s:finder_select')
    \}))
endfunction

function! s:finder_select(lines)
    let l:key = a:lines[0]
    let l:pick = a:lines[1]
    if l:pick == ''
        return
    endif

    let l:dir = isdirectory(l:pick) ? l:pick :
        \fnamemodify(l:pick, ':h') . '/'

    if l:key == 'ctrl-n'
        call s:finder_new_file(l:dir)
    elseif l:key == 'ctrl-v'
        call s:finder_action(l:pick)
    elseif !isdirectory(l:pick) && has_key(s:sink_by_key, l:key)
        execute s:sink_by_key[l:key] l:pick
    endif
endfunction

function! s:finder_new_file(dir) abort
    let l:inp = input('new file: ' . a:dir)
    let l:file = substitute(l:inp, ' .*$', '', '')
    if len(l:file) > 0
        if l:inp =~ ' s\(p\(lit\)\?\)\?$'
            let l:cmd = 'split'
        elseif l:inp =~ ' v\(ert\(ical\)\?\)\?\( \?s\(p\(lit\)\?\)\?\)\?$'
            let l:cmd = 'vsplit'
        else
            let l:cmd = 'edit'
        endif
        call system('mkdir -p ' . fnamemodify(a:dir . l:file, ':h'))
        execute l:cmd a:dir . l:file
    endif
endfunction

function! s:finder_action(pick) abort
    let l:cmd = input('{' . a:pick . '}: ')
    if len(l:cmd) > 0
        let l:out = system(substitute(l:cmd, '{}', a:pick, ''))
        echo substitute(l:out, '\n', '', '')
    endif
endfunction

" dynamic ripgrep --------------------------------------------------------------

function! s:rgi_select(lines) abort
    let l:key = a:lines[0]

    let l:fields = split(a:lines[1], ':')
    let l:query = l:fields[0][1:-2]
    let l:file = l:fields[1]
    let l:line = l:fields[2]
    let l:column = l:fields[3]

    if !has_key(s:sink_by_key, l:key)
        return
    endif

    execute s:sink_by_key[l:key] l:file
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
            \'--preview-window', 'right,70%,wrap,border-left,nohidden',
            \'--preview', 'bat --style=numbers --color=always --line-range={3}: {2} 2>/dev/null ' .
                \'| rg --color always --context 10 {q}',
            \'--expect', 'ctrl-o,ctrl-u'
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
