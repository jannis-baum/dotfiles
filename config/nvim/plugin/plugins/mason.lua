require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
    }
})
-- automatic dynamic server setup
require('mason-lspconfig').setup_handlers({
    function (server_name) -- default handler
        require('lspconfig')[server_name].setup {}
    end
})
