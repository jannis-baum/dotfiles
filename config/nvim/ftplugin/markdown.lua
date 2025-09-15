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
