-- Core plugins: which-key, fzf-lua, treesitter, etc.

return {
  -- Detect tabstop and shiftwidth automatically
  'NMAC427/guess-indent.nvim',

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '│' },
        topdelete = { text = '│' },
        changedelete = { text = '│' },
      },
      signs_staged = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '│' },
        topdelete = { text = '│' },
        changedelete = { text = '│' },
      },
    },
  },

  -- Which-key for keybind help
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 500,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Toggle' },
      },
    },
  },

  -- fzf-lua fuzzy finder (faster alternative to Telescope)
  {
    'ibhagwan/fzf-lua',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local fzf = require 'fzf-lua'
      
      -- Setup with telescope defaults for familiar keybindings and behavior
      fzf.setup {
        'telescope',
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = {
            layout = 'vertical',
            vertical = 'down:45%',
          },
        },
      }

      -- LazyVim-style keymaps
      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Search text' })
      vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Open buffers' })
      vim.keymap.set('n', '<leader>fr', fzf.oldfiles, { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>fc', fzf.grep_cword, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Help docs' })
      vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = 'Keymaps' })
      vim.keymap.set('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Diagnostics' })
      vim.keymap.set('n', '<leader>fs', fzf.builtin, { desc = 'Fzf commands' })

      -- Kickstart-style keymaps (keeping these for compatibility)
      vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = 'Search keymaps' })
      vim.keymap.set('n', '<leader>sf', fzf.files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = 'Search commands' })
      vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = 'Search by grep' })
      vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = 'Search diagnostics' })
      vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = 'Resume search' })
      vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = 'Search recent files' })

      -- Current buffer fuzzy search
      vim.keymap.set('n', '<leader>/', fzf.blines, { desc = 'Search in buffer' })

      -- Search in open files
      vim.keymap.set('n', '<leader>s/', function()
        fzf.live_grep {
          grep_opts = '--vimgrep',
          file_ignore_patterns = { 'node_modules', '.git' },
          prompt = 'Live Grep in Open Files> ',
        }
      end, { desc = 'Search in open files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        fzf.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search nvim config' })
    end,
  },

  -- Treesitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'tsx',
        'json',
        'yaml',
        'kotlin',
        'dockerfile',
        'sql',
        'prisma',
        'rust',
        'toml',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  -- Mini.nvim collection
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()
    end,
  },

  -- Todo comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
