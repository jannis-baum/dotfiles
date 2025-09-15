-- extend gx to open sioyek references -----------------------------------------

-- default implementation of gx from
-- /opt/homebrew/Cellar/neovim/0.11.3/share/nvim/runtime/lua/vim/_defaults.lua
local function do_open(uri)
    local cmd, err = vim.ui.open(uri)
    local rv = cmd and cmd:wait(1000) or nil
    if cmd and rv and rv.code ~= 0 then
        err = ('vim.ui.open: command %s (%d): %s'):format(
            (rv.code == 124 and 'timeout' or 'failed'),
            rv.code,
            vim.inspect(cmd.cmd)
        )
    end
    return err
end
local function original_gx()
    for _, url in ipairs(require('vim.ui')._get_urls()) do
        local err = do_open(url)
        if err then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end
end
-- default implementation end

-- sioyek gx extension
vim.keymap.set('n', 'gx', function()
    local line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based indexing
    local pattern = '%[([%w%._%/%-]+%s+%d+%s+[-%d]+)%]'
    -- \[[a-zA-Z0-9_.\/-]\s+[-\d]+\s+[-\d]+\]
    local s, e, match = line:find(pattern)

    if s and e and cursor_col >= s and cursor_col <= e then
        local args = { 'sio' }
        for str in string.gmatch(match, '([^%s]+)') do
            table.insert(args, str)
        end
        vim.system(args)
    else
        -- fallback to default gx behavior
        original_gx()
    end
end, { noremap = true, silent = true })

-- insert sioyek ref
vim.keymap.set('i', '<c-u>', function()
    local ref = vim.system({ 'sio', '--get' }):wait().stdout:gsub('\n', '')
    if ref == '' then return end

    local text_to_insert = '[' .. ref .. ']'
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local new_line = line:sub(1, col + 1) .. text_to_insert .. line:sub(col + 2)

    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col + #text_to_insert })
end, { noremap = true, silent = true })
