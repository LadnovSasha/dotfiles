-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- Create an autocommand group
vim.api.nvim_create_augroup("CustomIndent", {})

-- Define indentation rules per filetype
vim.api.nvim_create_autocmd("FileType", {
  group = "CustomIndent",
  pattern = "javascript,typescript",
  callback = function()
    vim.bo.shiftwidth = 4
    -- vim.bo.tabstop = 2
    -- vim.bo.softtabstop = 2
    -- vim.bo.expandtab = true  -- Use spaces instead of tabs
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "CustomIndent",
  pattern = "prisma",
  callback = function()
    vim.bo.shiftwidth = 2
    -- vim.bo.tabstop = 2
    -- vim.bo.softtabstop = 2
    -- vim.bo.expandtab = true  -- Use spaces instead of tabs
  end,
})

-- yank_shift
-- Shift numbered registers up (1 becomes 2, etc.)
local function yank_shift()
  for i = 9, 1, -1 do
    vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
  end
end
-- Create autocmd for TextYankPost event
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    if event.operator == "y" then
      yank_shift()
    end
  end,
})
-- end
