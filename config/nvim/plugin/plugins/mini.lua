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

require('mini.surround').setup({
    mappings = {
        add = ';a',        -- Add surrounding in Normal and Visual modes
        delete = ';d',     -- Delete surrounding
        find = ';f',       -- Find surrounding (to the right)
        find_left = ';F',  -- Find surrounding (to the left)
        highlight = ';h',  -- Highlight surrounding
        replace = ';r',    -- Replace surrounding
        update_n_lines = ';n', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
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
