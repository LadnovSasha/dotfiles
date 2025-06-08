return {
  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = false,
        shell = "zellij",
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 3,
        },
      })
    end,
  },
}
