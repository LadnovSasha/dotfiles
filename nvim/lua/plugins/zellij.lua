return {
  {
    "fresh2dev/zellij.vim",
    lazy = false,
    config = function()
      -- Auto-detect if running in zellij
      if os.getenv("ZELLIJ") then
        vim.g.zellij_navigator_no_wrap = 1
      end
    end,
  },
}
