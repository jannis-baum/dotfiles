if vim.fn.executable("ruff") == 1 then
  vim.bo.formatprg = "ruff check --select I --fix --exit-zero --quiet - | ruff format -"
end
