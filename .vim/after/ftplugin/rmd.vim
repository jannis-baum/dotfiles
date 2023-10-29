function! s:RenderRMarkdown()
    let l:out = substitute(system('mktemp'), '\n', '', 'g') . '.html'
    call system('R -e "library(rmarkdown); render(''' . expand('%:p') . ''', output_file = ''' . l:out . ''')"')
    call system('open ' . l:out)
endfunction

command! RMD call s:RenderRMarkdown()
