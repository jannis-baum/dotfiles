local notify = require('mini.notify')
notify.setup({
    window = {
        config = { border = 'solid' },
        winblend = 0,
    },
})
vim.notify = notify.make_notify({})
vim.keymap.set('n', '<leader>m', notify.show_history, { noremap = true, silent = true })

require('mini.ai').setup({
    search_method = 'cover_or_next',
    custom_textobjects = {
        -- bracket aliases
        b = { '%b()', '^.().*().$' },
        r = { '%b{}', '^.().*().$' },
        t = { '%b[]', '^.().*().$' },
        -- quotation aliases
        q = { "%b''", '^.().*().$' },
        Q = { '%b""', '^.().*().$' },
    }
})

-- remove default mapping of ; that we don't need because of sneak and instead
-- use for surround
vim.keymap.del('n', ';')
require('mini.surround').setup({
    search_method = 'cover_or_next',
    mappings = {
        add = ';a',          -- add surrounding in Normal and Visual modes
        delete = ';d',       -- delete surrounding
        replace = ';r',      -- replace surrounding
        find = '',           -- find surrounding (to the right)
        find_left = '',      -- find surrounding (to the left)
        highlight = '',      -- highlight surrounding
        update_n_lines = '', -- update `n_lines`

        suffix_last = 'l', -- suffix to search with "prev" method
        suffix_next = 'n', -- suffix to search with "next" method
    },
    custom_surroundings = {
        -- bracket aliases
        b = { input = { '(.-)', '^.().*().$' }, output = { left = '(', right = ')' } },
        r = { input = { '{.-}', '^.().*().$' }, output = { left = '{', right = '}' } },
        t = { input = { '%[.-%]', '^.().*().$' }, output = { left = '[', right = ']' } },
        -- quotation aliases
        q = { input = { "'.-'", '^.().*().$' }, output = { left = "'", right = "'" } },
        Q = { input = { '".-"', '^.().*().$' }, output = { left = '"', right = '"' } },
    }
})
