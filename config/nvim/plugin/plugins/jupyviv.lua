require('jupyviv').setup()

vim.keymap.set('n', '<leader>jr', ':JupyvivRunHere<CR>')
vim.keymap.set('v', '<leader>jr', ":'<,'>JupyvivRunSelection<CR>")
vim.keymap.set('n', '<leader>ja', ':JupyvivRunAll<CR>')
vim.keymap.set('n', '<leader>j;', ':Jupyviv')
