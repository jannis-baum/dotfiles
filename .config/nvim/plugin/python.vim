let s:env_name = 'py3nvim'
let g:python3_host_prog = stdpath('data') . '/' . s:env_name . '/bin/python'

" check if the python env is there, if yes stop sourcing this file
if executable(g:python3_host_prog)
    finish
endif

" if not create the python env & install pynvim
call system('cd ' . stdpath('data') . '; pyenv exec python3 -m venv ' . s:env_name)
call system(g:python3_host_prog . ' -m pip install --upgrade pynvim')
