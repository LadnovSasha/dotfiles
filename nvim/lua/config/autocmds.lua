-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Create an autocommand group
vim.api.nvim_create_augroup('CustomIndent', {})

-- Define indentation rules per filetype
vim.api.nvim_create_autocmd('FileType', {
  group = 'CustomIndent',
  pattern = 'javascript,typescript,tsx,jsx',
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true -- Use spaces instead of tabs
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'CustomIndent',
  pattern = 'prisma,yml,yaml,lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true -- Use spaces instead of tabs
  end,
})
