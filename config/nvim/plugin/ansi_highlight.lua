-- get hl keys (e.g. semantic tokens, treesitter, syntax) in priority order
local _hl_priorities = nil
local function get_hl_priorities()
    if _hl_priorities ~= nil then return _hl_priorities end
    _hl_priorities = {}
    local original = vim.hl.priorities
    for key in pairs(original) do
        table.insert(_hl_priorities, key)
    end
    table.sort(_hl_priorities, function(a, b)
        return original[a] > original[b]
    end)
    return _hl_priorities
end

-- get `nvim_get_hl` value for inspection data
local function get_hl(inspect_data)
    -- check elements by order of `vim.hl.priorities`
    local hl_priorities = get_hl_priorities()
    for _, capture_key in ipairs(hl_priorities) do
        local captures = inspect_data[capture_key]
        if captures ~= nil and next(captures) ~= nil then
            -- get last name of capture item of highest priority element
            local capture = captures[#captures]
            -- ['hl_group'] for semantic tokens & syntax,
            -- ['opts']['hl_group'] for treesitter
            local hl_group = capture['hl_group'] or capture['opts']['hl_group']
            -- get syntax hl ID and "translate" it/resolve links (nvim_get_hl
            -- also has link resolving option but it doesn't seem to work)
            local hl_id = vim.fn.synIDtrans(vim.fn.hlID(hl_group))
            local hl = vim.api.nvim_get_hl(0, { id = hl_id })
            -- check that there is actually defined highlighting, else we fall
            -- back to the next capture/lower priority hl key
            if next(hl) ~= nil then return hl end
        end
    end
end

local function get_ansi(hl)
    return hl
end

local function ansi_text(node, buf)
    local start_line, _, end_line, _ = node:range()
    local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
    for i, line_text in ipairs(lines) do
        local line_num = start_line - 1 + i
        for col = 0, #line_text - 1 do
            local inspect_data = vim.inspect_pos(buf, line_num, col)
            local hl = get_hl(inspect_data)
            -- - translate hl to ansi & return ansi string
            -- - run `get_hl()`, check if ansi has changed. if so, add it to the
            --   string
        end
    end
end

function TSHLTest()
    local parser = vim.treesitter.get_parser(0)
    if parser == nil then return end
    local parse_result = parser:parse(true)
    if parse_result == nil then return end

    local root = parse_result[1]:root()
    vim.print(ansi_text(root, 0))
end

function TSHLTest2()
    local inspection = vim.inspect_pos()
    local hl = get_hl(inspection)
    vim.print(hl)
end

TSHLTest2()
