-- PACK & PLUGINS -----------------------------------------------------
vim.pack.add({
    -- editing
    { src = 'https://github.com/echasnovski/mini.pairs', version = 'main' }, -- we use main here because stable still overwrites user <cr> mappings
    'https://github.com/tpope/vim-commentary',
    { src = 'https://github.com/echasnovski/mini.splitjoin', version = 'stable' },
    -- moves
    'https://github.com/justinmk/vim-sneak',
    { src = 'https://github.com/echasnovski/mini.ai', version = 'stable' },
    { src = 'https://github.com/echasnovski/mini.surround', version = 'stable' },
    { src = 'https://github.com/echasnovski/mini.operators', version = 'stable' },
    { src = 'https://github.com/echasnovski/mini.diff', version = 'stable' },
    -- ui
    'https://github.com/nvim-focus/focus.nvim',
    { src = 'https://github.com/echasnovski/mini.notify', version = 'stable' },
    -- misc
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/hat0uma/csvview.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter.git'
})

-- PYTHON -------------------------------------------------------------
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
