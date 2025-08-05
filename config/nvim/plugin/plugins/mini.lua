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
    mappings = {
        around = 'a',
        around_last = 'aN',
        around_next = 'an',

        inside = 'i',
        inside_last = 'iN',
        inside_next = 'in',

        goto_left = '',
        goto_right = '',
    },
    custom_textobjects = {
        -- bracket aliases
        ['l'] = { '%b()', '^.().*().$' },
        ['.'] = { '%b{}', '^.().*().$' },
        ['o'] = { '%b[]', '^.().*().$' },
        -- quotation aliases
        ['d'] = { "%b''", '^.().*().$' },
        ['s'] = { '%b""', '^.().*().$' },
        ['e'] = { '%b``', '^.().*().$' },
    }
})

require('mini.surround').setup({
    search_method = 'cover_or_next',
    mappings = {
        add = ';',           -- add surrounding in Normal and Visual modes
        delete = ';d',       -- delete surrounding
        replace = ';r',      -- replace surrounding
        find = '',           -- find surrounding (to the right)
        find_left = '',      -- find surrounding (to the left)
        highlight = '',      -- highlight surrounding
        update_n_lines = '', -- update `n_lines`

        suffix_last = 'N', -- suffix to search with "prev" method
        suffix_next = 'n', -- suffix to search with "next" method
    },
    custom_surroundings = {
        -- bracket aliases
        ['l'] = { input = { '%(.-%)', '^.().*().$' }, output = { left = '(', right = ')' } },
        ['.'] = { input = { '{.-}', '^.().*().$' }, output = { left = '{', right = '}' } },
        ['o'] = { input = { '%[.-%]', '^.().*().$' }, output = { left = '[', right = ']' } },
        -- quotation aliases
        ['d'] = { input = { "'.-'", '^.().*().$' }, output = { left = "'", right = "'" } },
        ['s'] = { input = { '".-"', '^.().*().$' }, output = { left = '"', right = '"' } },
        ['e'] = { input = { '`.-`', '^.().*().$' }, output = { left = '`', right = '`' } },
    }
})

require('mini.operators').setup({
    evaluate = { prefix = '' },
    exchange = { prefix = '' },
    multiply = { prefix = 'gm' },
    replace = { prefix = 'gp' },
    sort = { prefix = '' },
})

require('mini.pairs').setup()

require('mini.diff').setup({
    view = {
        signs = { add = '+', change = '~', delete = '-' },
        priority = 5
    },
    mappings = {
        goto_prev = 'M',
        goto_next = 'm',
    }
})

local splitjoin = require('mini.splitjoin')
splitjoin.setup({
    mappings = {
        toggle = 'gs'
    },
    join = {
        hooks_post = {
            -- add spaces inside of curly braces when joining
            splitjoin.gen_hook.pad_brackets({ brackets = { '%b{}' } })
        }
    }
})
