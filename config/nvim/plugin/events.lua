-- auto nohlsearch from @tuurep/dotfiles
local searchkeys = { "n", "N", "*", "#" }
vim.on_key(function(key)
    if vim.v.hlsearch == 0 then return end
    if not vim.tbl_contains(searchkeys, key) then
        vim.cmd.nohlsearch()
    end
end)
