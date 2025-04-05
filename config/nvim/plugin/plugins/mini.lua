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
