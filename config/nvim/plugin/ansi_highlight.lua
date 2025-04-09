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
            for i = 1, #captures do
                local capture = captures[#captures + 1 - i]
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
end

local ansi_reset = '\27[0m'

-- attributes handled the same in cterm and gui
local function add_ansi_attr_codes(codes, attrs)
    if attrs == nil then return end
    if attrs.bold then table.insert(codes, '1') end
    if attrs.italic then table.insert(codes, '3') end
    if attrs.underline then table.insert(codes, '4') end
    if attrs.inverse then table.insert(codes, '7') end
    if attrs.strikethrough then table.insert(codes, '9') end
end

local function get_ansi_cterm(hl)
    if hl == nil then return ansi_reset end
    -- cterm-specific foreground/background color
    local function get_ansi_color_code(attr, num)
        if not num then return nil end
        -- first 16 colors are handled differently
        if num < 16 then
            if attr == 'fg' then
                return num < 8 and tostring(30 + num) or tostring(90 + (num - 8))
            else
                return num < 8 and tostring(40 + num) or tostring(100 + (num - 8))
            end
        else
            return string.format('%s;5;%d', (attr == 'fg' and '38' or '48'), num)
        end
    end

    local codes = {}
    table.insert(codes, get_ansi_color_code('fg', hl['ctermfg']))
    table.insert(codes, get_ansi_color_code('bg', hl['ctermbg']))
    add_ansi_attr_codes(codes, hl['cterm'])

    -- no codes -> reset
    if next(codes) == nil then return ansi_reset end
    return '\27[' .. table.concat(codes, ';') .. 'm'
end

local function ansi_text(start_line, end_line, buf)
    local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local result_lines = {}

    -- assume starting with no highlighting/reset
    local prev_ansi = ansi_reset
    for i, line_text in ipairs(lines) do
        local result_line = ''
        local line_num = start_line - 1 + i
        for col = 0, #line_text - 1 do
            local inspect_data = vim.inspect_pos(buf, line_num, col)
            local hl = get_hl(inspect_data)
            local ansi = get_ansi_cterm(hl)
            if ansi ~= prev_ansi then
                result_line = result_line .. ansi
                prev_ansi = ansi
            end
            result_line = result_line .. line_text:sub(col + 1, col + 1)
        end
        table.insert(result_lines, result_line)
    end

    return table.concat(result_lines, '\n')
end

function TSHLTest()
    local parser = vim.treesitter.get_parser(0)
    if parser == nil then return end
    local parse_result = parser:parse(true)
    if parse_result == nil then return end

    local root = parse_result[1]:root()
    local start_line, _, end_line, _ = root:range()
    local text = ansi_text(start_line, end_line, 0)
    local fp = io.open('deleteme.txt', 'w')
    if fp == nil then
        vim.print('fp is nil')
        return
    end
    fp:write(text)
    fp:close()
end
