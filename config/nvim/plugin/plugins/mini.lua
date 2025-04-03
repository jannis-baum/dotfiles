require('mini.notify').setup()
vim.notify = MiniNotify.make_notify()
vim.keymap.set('n', '<leader>m', MiniNotify.show_history, { noremap = true, silent = true })
