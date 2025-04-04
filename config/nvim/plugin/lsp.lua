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

-- open completion with <down> key
vim.keymap.set('i', '<down>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', false)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n', false)
    end
end, { noremap = true })

vim.cmd('set completeopt+=menuone,noselect,popup')

-- DIAGNOSTICS -----------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = {
        current_line = true,
    },
    signs = { text = {
        [vim.diagnostic.severity.ERROR] = '􀒉',
        [vim.diagnostic.severity.WARN] = '􀇾',
        [vim.diagnostic.severity.INFO] = '􀛣',
        [vim.diagnostic.severity.HINT] = '􀛣',
    } }
})

vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.setloclist({ open = true })
end)
