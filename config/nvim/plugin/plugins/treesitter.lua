require 'nvim-treesitter.configs'.setup({
    ensure_installed = 'all',
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    -- List of parsers to ignore installing (or "all")
    ignore_install = {
        'comment', -- too complicated comment parsing
        'luadoc', -- very broken and inconsistent, looks best as just comment
        'luap'   -- too complicated regex parsing in lua
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    modules = {}
})

local main_symbols = {
    'function_declaration', 'function_definition',
    'class_declaration', 'class_definition'
}
local blacklist_symbols = {
    'comment'
}

local function inspect_node(node, depth, storage)
    local type = node:type()
    if (depth == 1 and not vim.list_contains(blacklist_symbols, type)) or vim.list_contains(main_symbols, type) then
        table.insert(storage, { depth = depth, node = node })
    end
    for _, child in ipairs(node:named_children()) do
        inspect_node(child, depth + 1, storage)
    end
end

local function fzf_line(node, depth)
    local row, column, _ = node:start()
    row = row + 1
    column = column + 1
    local text = string.rep(' ', (depth - 1) * 2) .. string.sub(vim.fn.getline(row), column)
    return tostring(row) .. ':' .. tostring(column) .. ':' .. text
end

function MainSymbols()
    local parser = vim.treesitter.get_parser(0)
    if parser == nil then return end
    local parse_result = parser:parse(true)
    if parse_result == nil then return end

    local root = parse_result[1]:root()
    local results = {}
    inspect_node(root, 0, results)
    local fzf_lines = {}
    for _, result in pairs(results) do
        table.insert(fzf_lines, fzf_line(result['node'], result['depth']))
    end
    return table.concat(fzf_lines, '\n')
end
