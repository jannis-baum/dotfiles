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


local function get_hl(inspect_data)
    local hl_priorities = get_hl_priorities()
    for _, capture_key in ipairs(hl_priorities) do
        local captures = inspect_data[capture_key]
        if captures ~= nil and next(captures) ~= nil then
            local capture = captures[#captures]
            local hl = capture['hl_group'] or capture['opts']['hl_group']
            return hl
        end
    end
    -- - check elements by order of `vim.hl.priorities`
    -- - get last name of capture item of highest priority element
    -- - use `hlID('<name>')` to get syntax hl ID
    -- - use `synIDtrans(<syntax hl ID>)` to get translated syntax ID (e.g.
    --   resolve links)
    -- - use `synIDattr(<translated syntax ID>)` to get highlight attributes,
    --   e.g. fg/bg/bold/italic/etc
    -- - translate hl to ansi & return ansi string
end

local function ansi_text(node, buf)
    local start_line, _, end_line, _ = node:range()
    local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
    for i, line_text in ipairs(lines) do
        local line_num = start_line - 1 + i
        for col = 0, #line_text - 1 do
            local inspect_data = vim.inspect_pos(buf, line_num, col)
            local hl = get_hl(inspect_data)
            -- run `get_hl()`, check if ansi has changed. if so, add it to the
            -- string
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
    -- run this on all cells
    -- check treesitter, syntax & semantic_tokens and get the *last* hl that this defines
    local inspection = vim.inspect_pos()
    vim.print(get_hl(inspection))
end
