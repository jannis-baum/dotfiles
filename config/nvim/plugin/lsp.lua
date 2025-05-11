-- COMPLETION ------------------------------------------------------------------

-- automatically start completion
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- sensible menu config
vim.cmd('set completeopt+=menuone,noselect,popup,fuzzy')

-- open completion with <down> key if not open, else select next
vim.keymap.set('i', '<down>', function()
    -- if pum is visible: select next
    if vim.fn.pumvisible() == 1 then
        return '<C-n>'
    end
    -- else open pum without `noselect` so we already select the first match
    vim.opt.completeopt:remove('noselect')
    -- reset to `noselect` after this completion
    vim.api.nvim_create_autocmd('CompleteDone', {
        once = true,
        callback = function() vim.opt.completeopt:append('noselect') end
    })
    -- open completion menu
    return '<C-x><C-o>'
end, { expr = true, noremap = true })

-- select previous item with <up> key
vim.keymap.set('i', '<up>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<up>'
end, { expr = true, noremap = true})

-- reset completion with <bs> (backspace) when pum is open and an item is
-- selected
vim.keymap.set('i', '<bs>', function()
    local info = vim.fn.complete_info()
    if info.pum_visible == 1 and info.selected > -1 then
        return '<C-e><C-x><C-o>'
    end
    return '<bs>'
end, { expr = true, noremap = true })

-- remap <return> to accept completion and apply side effects (like <c-y>)
vim.keymap.set('i', '<cr>', function()
    return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true, noremap = true})

-- DIAGNOSTICS -----------------------------------------------------------------

-- settings
local diagnostic_symbols = {
    [vim.diagnostic.severity.ERROR] = '×',
    [vim.diagnostic.severity.WARN] = '•',
    [vim.diagnostic.severity.INFO] = '◦',
    [vim.diagnostic.severity.HINT] = '◦',
}
vim.diagnostic.config({
    virtual_text = {
        current_line = true,
        virt_text_pos = 'eol_right_align',
        prefix = function(diagnostic)
            return diagnostic_symbols[diagnostic.severity] .. ' '
        end
    },
    signs = {
        text = diagnostic_symbols,
        priority = 10,
    },
    severity_sort = true,
})

-- fzf picker
local ansi = require('ansi_highlight')
local path_ansi = ansi.hl_to_ansi('Comment')
local diagnostic_ansi = {
    [vim.diagnostic.severity.ERROR] = ansi.hl_to_ansi('DiagnosticError'),
    [vim.diagnostic.severity.WARN] = ansi.hl_to_ansi('DiagnosticWarn'),
    [vim.diagnostic.severity.INFO] = ansi.hl_to_ansi('DiagnosticInfo'),
    [vim.diagnostic.severity.HINT] = ansi.hl_to_ansi('DiagnosticHint'),
}
vim.keymap.set('n', '<leader>d', function()
    local diagnostics = vim.diagnostic.get(nil)
    local current_bufnr = vim.api.nvim_get_current_buf()

    table.sort(diagnostics, function(a, b)
        -- sort current buffer above
        local a_is_current = a['bufnr'] == current_bufnr
        local b_is_current = b['bufnr'] == current_bufnr
        if a_is_current ~= b_is_current then
            return a_is_current
        -- sort by buffer, then severity, then line number
        elseif a['bufnr'] ~= b['bufnr'] then
            return a['bufnr'] < b['bufnr']
        elseif a['severity'] ~= b['severity'] then
            return a['severity'] < b['severity']
        end
        return a['lnum'] < b['lnum']
    end)

    local fzf_input = vim.tbl_map(function(diagnostic)
        -- label: colored diagnostic symbol
        local label = diagnostic_ansi[diagnostic['severity']] .. diagnostic_symbols[diagnostic['severity']]
        -- label: space
        label = label .. path_ansi .. ' '
        -- label: relative path for other buffers
        if diagnostic['bufnr'] ~= current_bufnr then
            local bufname = vim.api.nvim_buf_get_name(diagnostic['bufnr'])
            local relpath = vim.fn.fnamemodify(bufname, ":.")
            label = label .. relpath .. ' '
        end
        -- label: message
        label = label .. ansi.ansi_reset .. diagnostic['message']
        -- full fzf line
        return table.concat({
            diagnostic['bufnr'], diagnostic['lnum'], diagnostic['col'], label
        }, ':')
    end, diagnostics)

    local fzf_wrap = vim.fn['fzf#wrap']({
        source = fzf_input,
        options = {
            '--delimiter', ':',
            '--with-nth', '4..',
            '--ansi',
        },
        sink = function(line)
            local bufnr, row, column = string.match(line, '([^:]+):([^:]+):([^:]+)')
            vim.cmd('buffer ' .. bufnr)
            vim.fn.setpos('.', { bufnr, row + 1, column + 1 })
        end
    })
    vim.fn['fzf#run'](fzf_wrap)
end)

-- SIGNATURE HELP --------------------------------------------------------------

vim.keymap.set('i', '<C-o>', function()
    vim.lsp.buf.signature_help({
        focussable = false,
        focus = false,
    })
end)

-- KEYMAPS ---------------------------------------------------------------------

-- useful defaults:
--   grn in Normal mode maps to vim.lsp.buf.rename()
--   grr in Normal mode maps to vim.lsp.buf.references()
--   gri in Normal mode maps to vim.lsp.buf.implementation()
--   gra in Normal and Visual mode maps to vim.lsp.buf.code_action()

vim.keymap.set('n', 'grd', vim.lsp.buf.definition)
