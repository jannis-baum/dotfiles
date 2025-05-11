require('jupyviv').setup()

vim.keymap.set('n', '<leader>jr', Jupyviv.run_here)
vim.keymap.set('n', '<leader>ja', Jupyviv.run_all)
vim.keymap.set('n', '<leader>j;', ':Jupyviv')
