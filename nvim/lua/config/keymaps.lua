-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- System clipboard
keymap.set("v", "<C-c>", '"+y', opts)
keymap.set("v", "<C-x>", '"+d', opts)
keymap.set("n", "<C-c>", '"+yy', opts)
keymap.set("n", "<C-x>", '"+dd', opts)
-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><", opts)
keymap.set("n", "<C-S-l>", "<C-w>>", opts)
keymap.set("n", "<C-S-k>", "<C-w>+", opts)
keymap.set("n", "<C-S-j>", "<C-w>-", opts)
