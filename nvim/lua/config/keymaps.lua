-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostics' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Previous [D]iagnostic' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window resizing keymaps (migrated from LazyVim config)
vim.keymap.set('n', '<M-S-h>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<M-S-l>', '<C-w>>', { desc = 'Increase window width' })
vim.keymap.set('n', '<M-S-k>', '<C-w>+', { desc = 'Increase window height' })
vim.keymap.set('n', '<M-S-j>', '<C-w>-', { desc = 'Decrease window height' })

-- System clipboard keymaps (migrated from LazyVim config)
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true, desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true, desc = 'Cut to system clipboard' })
vim.keymap.set('n', '<C-c>', '"+yy', { noremap = true, silent = true, desc = 'Copy line to system clipboard' })
vim.keymap.set('n', '<C-x>', '"+dd', { noremap = true, silent = true, desc = 'Cut line to system clipboard' })

-- Preserve clipboard when pasting over visual selection
vim.keymap.set('x', 'p', '"_dP', { noremap = true, silent = true, desc = 'Paste without overwriting clipboard' })

-- Quick quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })
vim.keymap.set('n', '<leader>wq', '<cmd>q<cr>', { desc = 'Quit current buffer' })

-- Switch to most recent buffer (double leader)
vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Switch to recent buffer' })

-- LSP Keymaps
-- These keymaps are only active when an LSP is attached to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-keymaps', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- K to show diagnostics if present, otherwise show hover
    map('K', function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
      if #diagnostics > 0 then
        vim.diagnostic.open_float()
      else
        vim.lsp.buf.hover()
      end
    end, 'Hover Documentation or Diagnostics')

    -- Rename the variable under your cursor.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- Format document or selection
    map('<leader>cf', function()
      vim.lsp.buf.format { async = true }
    end, '[C]ode [F]ormat')

    -- Organize imports
    map('<leader>co', function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { 'source.organizeImports' },
        },
      }
    end, '[C]ode [O]rganize imports')

    -- Add missing imports
    map('<leader>cm', function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { 'source.addMissingImports' },
        },
      }
    end, '[C]ode Add [M]issing imports')
    -- Find references for the word under your cursor.
    map('grr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    map('gi', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    map('gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    map('gO', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    map('gW', require('fzf-lua').lsp_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    map('grt', require('fzf-lua').lsp_typedefs, '[G]oto [T]ype Definition')
  end,
})
