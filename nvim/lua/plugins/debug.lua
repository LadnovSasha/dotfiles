-- DAP debugging configuration

return {
  -- DAP debugging - LazyVim style setup
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'williamboman/mason.nvim',
      'rcarriga/nvim-dap-ui',
      -- virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    config = function()
      local dap = require('dap')

      -- Visual highlight for stopped line
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      -- DAP icons setup (Nerd Font icons)
      local icons = {
        Stopped = { '󰁕', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = '●',
        BreakpointCondition = '◆',
        BreakpointRejected = { '✖', 'DiagnosticError' },
        LogPoint = '◉',
      }

      for name, sign in pairs(icons) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
      end

      -- Configure js-debug-adapter installed via Mason
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }

      dap.adapters['pwa-chrome'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }

      dap.adapters['node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
          args = { '${port}' },
        },
      }

      -- Load VS Code launch.json configurations if they exist
      local vscode = require('dap.ext.vscode')
      local json = require('plenary.json')
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      pcall(function()
        vscode.load_launchjs(nil, {
          ['pwa-node'] = { 'javascript', 'typescript' },
          ['pwa-chrome'] = { 'javascript', 'typescript' },
          ['node'] = { 'javascript', 'typescript' },
        })
      end)
    end,
    keys = {
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Breakpoint Condition' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Run/Continue' },
      { '<leader>da', function() require('dap').continue() end, desc = 'Run with Args' },
      { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to Cursor' },
      { '<leader>dg', function() require('dap').goto_() end, desc = 'Go to Line (No Execute)' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<leader>dj', function() require('dap').down() end, desc = 'Down' },
      { '<leader>dk', function() require('dap').up() end, desc = 'Up' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'Run Last' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<leader>dO', function() require('dap').step_over() end, desc = 'Step Over' },
      { '<leader>dP', function() require('dap').pause() end, desc = 'Pause' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
      { '<leader>ds', function() require('dap').session() end, desc = 'Session' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
      { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'Widgets' },
    },
  },

  -- DAP UI
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      {
        '<Leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle DAP UI',
      },
      {
        '<Leader>de',
        function()
          require('dapui').eval()
        end,
        desc = 'Eval Expression',
        mode = { 'n', 'v' },
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup({
        controls = {
          element = 'repl',
          enabled = true,
          icons = {
            disconnect = '',
            pause = '',
            play = '',
            run_last = '',
            step_back = '',
            step_into = '',
            step_out = '',
            step_over = '',
            terminate = '',
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = 'single',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = '',
          current_frame = '',
          expanded = '',
        },
        layouts = {
          {
            elements = {
              {
                id = 'scopes',
                size = 0.25,
              },
              {
                id = 'breakpoints',
                size = 0.25,
              },
              {
                id = 'stacks',
                size = 0.25,
              },
              {
                id = 'watches',
                size = 0.25,
              },
            },
            position = 'left',
            size = 40,
          },
          {
            elements = {
              {
                id = 'repl',
                size = 0.5,
              },
              {
                id = 'console',
                size = 0.5,
              },
            },
            position = 'bottom',
            size = 10,
          },
        },
        mappings = {
          edit = 'e',
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          repl = 'r',
          toggle = 't',
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      })

      -- DAP UI auto-close on debugging end (but don't auto-open)
      dap.listeners.before.event_terminated['dapui_config'] = function()
        -- dapui.close() -- Commented out - manual control only
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        -- dapui.close() -- Commented out - manual control only
      end
    end,
  },
}