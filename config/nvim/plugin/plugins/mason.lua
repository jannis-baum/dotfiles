require('mason').setup()

require('mason-lspconfig').setup({
    -- available LSP servers:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    ensure_installed = {
        'lua_ls', 'vimls',
        'bashls',
        'clangd', 'cmake',
        'dockerls', 'docker_compose_language_service',
        'yamlls', 'jsonls',
        'ts_ls', 'eslint',
        'html', 'cssls', 'tailwindcss',
    },
    automatic_installation = true,
})

-- automatic dynamic server setup
require('mason-lspconfig').setup_handlers({
    function (server_name) -- default handler
        require('lspconfig')[server_name].setup {}
    end,
    ['lua_ls'] = function()
        require('lspconfig').lua_ls.setup {
            settings = {
                Lua = {
                    runtime = {
                        -- LuaJIT for NeoVim
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        -- global `vim`
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- avoid telemetry data
                    telemetry = {
                        enable = false,
                    },
                }
            }
        }
    end
})
