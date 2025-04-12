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

vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.setloclist({ open = true })
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
