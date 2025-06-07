return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    opts = {
      keymap = {
        ["<C-M-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },
  },
  {},
}
