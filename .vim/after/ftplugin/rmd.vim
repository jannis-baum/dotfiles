function! s:RenderRMarkdown()
    let l:out = substitute(system('mktemp'), '\n', '', 'g') . '.html'
    call system('R -e "library(rmarkdown); render(''R_1_example_import_SPSS.Rmd'', output_file = ''' . l:out . ''')"')
    call system('open ' . l:out)
endfunction

command! RMD call s:RenderRMarkdown()
