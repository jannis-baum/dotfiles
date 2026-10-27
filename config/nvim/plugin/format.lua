-- format whole file
vim.keymap.set("n", "<leader>f", function()
  -- without formatprg/formatexpr, gq falls back to joining lines into paragraphs, which mangles code
  if vim.bo.formatprg == "" and vim.bo.formatexpr == "" then
    return vim.notify("No formatter set for this filetype", vim.log.levels.WARN)
  end
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gggqG")
  if vim.v.shell_error ~= 0 then
    vim.cmd("undo")
    vim.notify("Formatter failed, buffer left unchanged", vim.log.levels.ERROR)
  end
  vim.fn.winrestview(view)
end, { desc = "Format file" })
