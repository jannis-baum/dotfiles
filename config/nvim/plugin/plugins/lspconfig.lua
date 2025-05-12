-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

vim.lsp.enable('lua_ls')
-- set up lua_ls for nvim
vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- LuaJIT for NeoVim
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = { 'lua/?.lua', 'lua/?/init.lua', },
            },
            -- Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME }
            }
        })
    end,
    settings = {
        Lua = {}
    }
})

vim.lsp.enable('bashls')

vim.lsp.enable('sourcekit')

vim.lsp.enable('pyright')

vim.lsp.enable('clangd')
vim.lsp.enable('cmake')

vim.lsp.enable('dockerls')

vim.lsp.enable('yamlls')
vim.lsp.enable('jsonls')

vim.lsp.enable('ts_ls')
vim.lsp.enable('eslint')
vim.lsp.enable('html')
vim.lsp.enable('cssls')
vim.lsp.enable('tailwindcss')

-- below are language servers not installed because there is no brew package for
-- them.
--
-- - could install with global npm install:
--   - vimls (https://github.com/iamcco/vim-language-server)
--   - docker_compose_language_service (https://github.com/microsoft/compose-language-service)
