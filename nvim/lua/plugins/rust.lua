-- Rust plugin configuration

return {
  -- Enhanced Rust development with rustaceanvim
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    config = function()
      local mason_registry = require('mason-registry')

      -- Setup default paths for codelldb
      local codelldb_path = nil
      local liblldb_path = nil

      -- Try to get codelldb from Mason if it's installed
      local ok, codelldb = pcall(mason_registry.get_package, 'codelldb')
      if ok and codelldb then
        local install_path = nil
        -- Check if the package is installed and get its path
        if codelldb:is_installed() then
          -- Try the new API first, fall back to old API
          if type(codelldb.get_install_path) == 'function' then
            install_path = codelldb:get_install_path()
          elseif type(codelldb.get_installed_path) == 'function' then
            install_path = codelldb:get_installed_path()
          end

          if install_path then
            local extension_path = install_path .. '/extension/'
            codelldb_path = extension_path .. 'adapter/codelldb'
            liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
          end
        end
      end

      -- Fallback to system codelldb if Mason package not found
      if not codelldb_path then
        -- Try to find codelldb in common locations
        local possible_paths = {
          vim.fn.expand('~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb'),
          '/usr/local/bin/codelldb',
          '/usr/bin/codelldb',
        }

        for _, path in ipairs(possible_paths) do
          if vim.fn.filereadable(path) == 1 then
            codelldb_path = path
            break
          end
        end
      end

      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          hover_actions = {
            auto_focus = false,
          },
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Set up buffer-local keymaps
            local opts = { buffer = bufnr, silent = true }

            -- Rust-specific keymaps
            vim.keymap.set('n', '<leader>rr', function()
              vim.cmd.RustLsp('runnables')
            end, { buffer = bufnr, desc = 'Rust Runnables' })
            vim.keymap.set('n', '<leader>rd', function()
              vim.cmd.RustLsp('debuggables')
            end, { buffer = bufnr, desc = 'Rust Debuggables' })
            vim.keymap.set('n', '<leader>re', function()
              vim.cmd.RustLsp('expandMacro')
            end, { buffer = bufnr, desc = 'Expand Macro' })
            vim.keymap.set('n', '<leader>rc', function()
              vim.cmd.RustLsp('openCargo')
            end, { buffer = bufnr, desc = 'Open Cargo.toml' })
            vim.keymap.set('n', '<leader>rp', function()
              vim.cmd.RustLsp('parentModule')
            end, { buffer = bufnr, desc = 'Parent Module' })
            vim.keymap.set('n', '<leader>rj', function()
              vim.cmd.RustLsp('joinLines')
            end, { buffer = bufnr, desc = 'Join Lines' })
            vim.keymap.set('n', '<leader>ra', function()
              vim.cmd.RustLsp('codeAction')
            end, { buffer = bufnr, desc = 'Code Action' })
            vim.keymap.set('n', '<leader>rR', function()
              vim.cmd.RustLsp('reloadWorkspace')
            end, { buffer = bufnr, desc = 'Reload Workspace' })

            -- Override K to show Rust hover actions
            vim.keymap.set('n', 'K', function()
              vim.cmd.RustLsp({ 'hover', 'actions' })
            end, opts)
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['napi-derive'] = { 'napi' },
                  ['async-recursion'] = { 'async_recursion' },
                },
              },
              inlayHints = {
                bindingModeHints = {
                  enable = false,
                },
                chainingHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                  minLines = 25,
                },
                closureReturnTypeHints = {
                  enable = 'never',
                },
                lifetimeElisionHints = {
                  enable = 'never',
                  useParameterNames = false,
                },
                maxLength = 25,
                parameterHints = {
                  enable = true,
                },
                reborrowHints = {
                  enable = 'never',
                },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
        },
        -- DAP configuration (only if codelldb is available)
        dap = codelldb_path and {
          adapter = {
            type = 'server',
            port = '${port}',
            executable = {
              command = codelldb_path,
              args = { '--port', '${port}' },
            },
          },
        } or nil,
      }
    end,
  },

  -- Cargo.toml features and dependency management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local crates = require('crates')
      crates.setup({
        popup = {
          autofocus = true,
          hide_on_select = false,
          copy_register = '"',
          style = 'minimal',
          border = 'rounded',
          show_version_date = true,
          show_dependency_version = true,
          max_height = 30,
          min_width = 20,
          padding = 1,
        },
        completion = {
          blink = {
            enabled = true,
          },
        },
      })

      -- Cargo.toml specific keymaps
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = 'Cargo.toml',
        callback = function()
          local opts = { buffer = true, silent = true }
          vim.keymap.set('n', '<leader>ct', crates.toggle, { buffer = true, desc = 'Toggle crates popup' })
          vim.keymap.set('n', '<leader>cr', crates.reload, { buffer = true, desc = 'Reload crates' })
          vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { buffer = true, desc = 'Show versions popup' })
          vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { buffer = true, desc = 'Show features popup' })
          vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, { buffer = true, desc = 'Show dependencies popup' })
          vim.keymap.set('n', '<leader>cu', crates.update_crate, { buffer = true, desc = 'Update crate' })
          vim.keymap.set('v', '<leader>cu', crates.update_crates, { buffer = true, desc = 'Update selected crates' })
          vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { buffer = true, desc = 'Update all crates' })
          vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, { buffer = true, desc = 'Upgrade crate' })
          vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, { buffer = true, desc = 'Upgrade selected crates' })
          vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, { buffer = true, desc = 'Upgrade all crates' })
        end,
      })
    end,
  },

  -- Better TOML support for Cargo.toml
  {
    'tamasfe/taplo',
    ft = 'toml',
  },
}

