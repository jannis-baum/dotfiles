-- TODO:
-- - multi line function definitions, e.g. with @attributes in Swift or Python

local ansi = require('ansi_highlight')

local relevant_symbols = {
    -- relevant symbols & examples for languages that use them
    'function_declaration', -- Lua
    'function_definition',  -- Python
    'class_declaration',    -- Lua
    'class_definition',     -- Python
    'class_specifier',      -- C++
    'init_declaration',     -- Swift
    'field_declaration',    -- C++
    'friend_declaration',   -- C++
    'lexical_declaration',  -- TypeScript
}
local blacklist_symbols = {
    'comment',               -- everything
    'import_statement',      -- Python
    'import_from_statement', -- Python
    'import_declaration',    -- Swift
    'preproc_include',       -- C
}

local function inspect_node(node, depth, storage)
    local type = node:type()
    if (depth == 1 and not vim.list_contains(blacklist_symbols, type)) or vim.list_contains(relevant_symbols, type) then
        table.insert(storage, { depth = depth, node = node })
    end
    for _, child in ipairs(node:named_children()) do
        inspect_node(child, depth + 1, storage)
    end
end

local function symbol_nodes()
    local parser = vim.treesitter.get_parser(0)
    if parser == nil then return end
    local parse_result = parser:parse(true)
    if parse_result == nil then return end

    local root = parse_result[1]:root()
    local results = {}
    inspect_node(root, 0, results)
    return results
end

local function fzf_sink(line)
    local row, column = string.match(line, '([^:]+):([^:]+)')
    vim.fn.setpos('.', { 0, row, column })
end

function SelectSymbol()
    local symbols = symbol_nodes()
    if symbols == nil then return end

    local fzf_input = {}
    local prev_row = 0
    for _, symbol in pairs(symbols) do
        local node = symbol['node']
        local depth = symbol['depth']
        local row, column, _ = node:start()
        -- omit if we already have something on this line, e.g. in Vimscript
        -- where there are both `function_declaration` and `function_definition`
        if prev_row == row then goto continue end

        local text = ansi.get(0, row, column, row, #vim.fn.getline(row + 1))
        local indented_text = string.rep(' ', (depth - 1) * 2) .. text
        table.insert(fzf_input, tostring(row + 1) .. ':' .. tostring(column + 1) .. ':' .. indented_text)
        prev_row = row
        ::continue::
    end

    local fzf_wrap = vim.fn['fzf#wrap']({
        source = fzf_input,
        options = {
            '--delimiter', ':',
            '--with-nth', '3..',
            '--ansi',
        },
        sink = fzf_sink
    })
    vim.fn['fzf#run'](fzf_wrap)
end

vim.keymap.set('n', '<cr>', function()
    if not pcall(SelectSymbol) then
        local key = vim.api.nvim_replace_termcodes('<cr>', true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    end
end, { noremap = true })
