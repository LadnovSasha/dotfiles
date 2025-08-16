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
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
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
      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Find by Grep' })
      vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find Buffers' })
      vim.keymap.set('n', '<leader>fr', fzf.oldfiles, { desc = 'Find Recent Files' })
      vim.keymap.set('n', '<leader>fc', fzf.grep_cword, { desc = 'Find current Word' })
      vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Find Help' })
      vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = 'Find Keymaps' })
      vim.keymap.set('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Find Diagnostics' })
      vim.keymap.set('n', '<leader>fs', fzf.builtin, { desc = 'Find Select fzf-lua' })

      -- Kickstart-style keymaps (keeping these for compatibility)
      vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
      vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Current buffer fuzzy search
      vim.keymap.set('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer' })

      -- Search in open files
      vim.keymap.set('n', '<leader>s/', function()
        fzf.live_grep {
          grep_opts = '--vimgrep',
          file_ignore_patterns = { 'node_modules', '.git' },
          prompt = 'Live Grep in Open Files> ',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        fzf.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
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

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their default behavior.
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Todo comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
