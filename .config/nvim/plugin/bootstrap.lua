local python_env_name = 'py3nvim'
vim.g.python3_host_prog = vim.fn.stdpath('data') .. '/' .. python_env_name .. '/bin/python'

local function bootstrap_python()
    if vim.fn.executable(vim.g.python3_host_prog) == 1 then
        return
    end
    vim.notify('Setting up Python environment')
    vim.fn.system { 'sh', '-c', 'cd ' .. vim.fn.stdpath('data') .. '; pyenv exec python3 -m venv ' .. python_env_name }
    vim.fn.system { vim.g.python3_host_prog, '-m', 'pip', 'install', '--upgrade', 'pynvim' }
end

bootstrap_python()
