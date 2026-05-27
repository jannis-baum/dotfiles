function! s:RenderRMarkdown()
    if !exists('g:rmd_out')
        let g:rmd_out = substitute(system('mktemp'), '\n', '', 'g') . '.html'
    endif

    write
    call system('R -e "library(rmarkdown); render(''' . expand('%:p') . ''', output_file = ''' . g:rmd_out . ''')"')
    call system('open ' . g:rmd_out)
endfunction

command! RMD call s:RenderRMarkdown()
