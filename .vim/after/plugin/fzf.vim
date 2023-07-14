let g:fzf_layout = { 'window': {
    \'width': 0.8, 'height': 0.6,
    \'yoffset': 0,
    \'border': 'sharp',
\} }

" git status file picker -------------------------------------------------------

function! s:gsi_select(lines) abort
    if len(a:lines) < 2
        return
    endif
    let l:file = split(a:lines[1], ':')[0]
    call s:finder_select([a:lines[0], l:file])
endfunction

function! s:gsi() abort
    call fzf#run(fzf#wrap({
        \'source': 'source $HOME/.zsh/scripts/git/_helpers.zsh && _git_interactive_status_helper',
        \'options': [
            \'--ansi',
            \'--exit-0',
            \'--delimiter', ':',
            \'--with-nth', '2',
            \'--expect=ctrl-o,ctrl-u,ctrl-n',
            \'--no-multi',
            \'--preview-window=right,60%,border-left,nohidden',
            \'--preview', 'git diff --color=always HEAD -- {1} | tail -n +5'
        \],
        \'sink*': function('s:gsi_select')
    \}))
endfunction

command! GSI call s:gsi()
noremap <silent> <leader>gs :GSI<CR>

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
