vim.keymap.set('i', '<c-u>', function()
    return Masi.insert_reference()
end, { noremap = true, silent = true, buffer = true })

vim.keymap.set({'n', 'x'}, '<leader>wc', function()
    return Masi.count_words()
end, { expr = true, silent = true, buffer = true })
