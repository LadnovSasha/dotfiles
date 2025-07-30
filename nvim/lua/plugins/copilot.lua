-- GitHub Copilot integration

return {
  -- GitHub Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = '<Tab>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  -- Copilot integration for blink-cmp
  -- This plugin provides a way to use GitHub Copilot with blink-cmp.
  {
    'giuxtaposition/blink-cmp-copilot',
    dependencies = {
      'zbirenbaum/copilot.lua',
    },
  },
}
