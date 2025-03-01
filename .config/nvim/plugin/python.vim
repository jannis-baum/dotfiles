let g:python3_host_prog = expand('~/.config/nvim/py3nvim/bin/python')

" check if the python env is there, if yes stop sourcing this file
if executable(g:python3_host_prog)
    finish
endif

" if not create the python env & install pynvim
call system('cd ~/.config/nvim; pyenv exec python3 -m venv py3nvim')
call system(g:python3_host_prog . ' -m pip install --upgrade pynvim')
