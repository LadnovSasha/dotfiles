-- Terminal and Zellij integration

return {
  -- Zellij navigation integration
  {
    'swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      -- We'll override the default Ctrl navigation if in Zellij
      if os.getenv('ZELLIJ') then
        require('zellij-nav').setup()
        vim.keymap.set('n', '<c-h>', '<cmd>ZellijNavigateLeft<cr>', { silent = true, desc = 'navigate left' })
        vim.keymap.set('n', '<c-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'navigate down' })
        vim.keymap.set('n', '<c-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'navigate up' })
        vim.keymap.set('n', '<c-l>', '<cmd>ZellijNavigateRight<cr>', { silent = true, desc = 'navigate right' })
      end
    end,
  },

  -- Additional Zellij support
  {
    'fresh2dev/zellij.vim',
    lazy = false,
    config = function()
      -- Auto-detect if running in zellij
      if os.getenv('ZELLIJ') then
        vim.g.zellij_navigator_no_wrap = 1
      end
    end,
  },

  -- Terminal integration
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = false,
        shell = 'zellij',
        direction = 'float',
        float_opts = {
          border = 'curved',
          winblend = 3,
        },
      })
    end,
  },
}