let g:fzf_layout = { 'window': {
    \'width': 0.8, 'height': 0.6,
    \'yoffset': 0,
    \'border': 'sharp',
\} }

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
