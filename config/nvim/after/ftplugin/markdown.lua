vim.keymap.set('i', '<c-u>', function()
    return Masi.insert_reference()
end, { noremap = true, silent = true, buffer = true })

vim.keymap.set({'n', 'x'}, '<leader>wc', function()
    return Masi.count_words()
end, { expr = true, silent = true, buffer = true })

-- text substitutions
local substitutions = {
  ['->'] = '→',
  ['<-'] = '←',
}
vim.api.nvim_create_autocmd('TextChangedI', {
  buffer = 0,
  callback = function()
    local col = vim.fn.col('.') - 1
    local line = vim.api.nvim_get_current_line()
    if line:sub(col, col) ~= ' ' then return end
    for trigger, replacement in pairs(substitutions) do
      local n = #trigger
      if col - 1 >= n and line:sub(col - n, col - 1) == trigger then
        local row = vim.fn.line('.') - 1
        vim.api.nvim_buf_set_text(0, row, col - n - 1, row, col - 1, { replacement })
        vim.api.nvim_win_set_cursor(0, { row + 1, col - n - 1 + #replacement + 1 })
        return
      end
    end
  end,
})
