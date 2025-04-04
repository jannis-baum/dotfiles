require('mason').setup()

require('mason-lspconfig').setup({
    -- available LSP servers:
    -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
    ensure_installed = {
        'lua_ls',
        'vimls',
    }
})

-- automatic dynamic server setup
require('mason-lspconfig').setup_handlers({
    function (server_name) -- default handler
        require('lspconfig')[server_name].setup {}
    end
})
