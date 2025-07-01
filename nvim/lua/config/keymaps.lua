-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostics' })
vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = 'Previous [D]iagnostic' })

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

-- Quick quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })
vim.keymap.set('n', '<leader>wq', '<cmd>q<cr>', { desc = 'Quit current buffer' })

-- Switch to most recent buffer (double leader)
vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Switch to recent buffer' })
