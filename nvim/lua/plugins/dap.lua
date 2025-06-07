local keymap = vim.keymap

return {
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = " npm i --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "mxsdev/nvim-dap-vscode-js",

    opts = {
      debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
      adapters = { "pwa-node", "pwa-chrome", "node", "node-terminal" },
    },

    keys = {
      {
        "<Leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<Leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
    },
  },
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      -- disable flashing DAP UI behavior
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close({})
      end
    end,
  },
}
