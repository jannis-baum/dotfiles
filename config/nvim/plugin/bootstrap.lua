-- PACK & PLUGINS -----------------------------------------------------
local function clone_paq()
    local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
    if not is_installed then
        vim.notify('Cloning paq')
        vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path }
        return true
    end
end

local function bootstrap_paq(packages)
    local first_install = clone_paq()
    vim.cmd.packadd('paq-nvim')
    local paq = require('paq')
    if first_install then
        vim.notify('Installing plugins... If prompted, hit Enter to continue.')
    end

    paq(packages)
    paq.install()
end

bootstrap_paq {
    'savq/paq-nvim',
    -- editing
    { 'echasnovski/mini.pairs', branch = 'stable' },
    'tpope/vim-commentary',
    'github/copilot.vim',
    'SirVer/ultisnips',
    -- moves
    'justinmk/vim-sneak',
    { 'echasnovski/mini.ai', branch = 'stable' },
    { 'echasnovski/mini.surround', branch = 'stable' },
    -- ui
    'nvim-focus/focus.nvim',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'echasnovski/mini.notify', branch = 'stable' },
    'airblade/vim-gitgutter',
    -- lsp
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    -- misc
    'tpope/vim-fugitive',
}

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
