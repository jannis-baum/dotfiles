require 'nvim-treesitter.configs'.setup({
    ensure_installed = 'all',
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    -- List of parsers to ignore installing (or "all")
    ignore_install = {
        'comment', -- too complicated comment parsing
        'luadoc', -- very broken and inconsistent, looks best as just comment
        'luap'   -- too complicated regex parsing in lua
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    modules = {}
})
