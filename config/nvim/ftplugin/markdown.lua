vim.keymap.set('i', '<c-u>', function()
    Masi.insert_reference()
end, { noremap = true, silent = true })
