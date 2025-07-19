-- LSP Configuration

return {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Setup LSP highlights
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-highlight', { clear = true }),
        callback = function(event)
          -- This function resolves a difference between neovim nightly and stable
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-document-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Configure specific LSP servers that need custom settings
      -- All other servers will use default settings
      local servers = {
        -- TypeScript/JavaScript with memory optimization
        ts_ls = {
          -- Use NODE_OPTIONS to increase memory limit
          cmd = {
            "env",
            "NODE_OPTIONS=--max-old-space-size=4096",
            "typescript-language-server",
            "--stdio"
          },
          init_options = {
            hostInfo = 'neovim',
            -- Limit tsserver memory usage
            maxTsServerMemory = 4096,
            preferences = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              importModuleSpecifierPreference = 'relative',
              includePackageJsonAutoImports = 'auto',
            },
          },
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 4096,
                useSingleInferredProject = true,
                disableAutomaticTypingAcquisition = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayFunctionParameterTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayFunctionParameterTypeHints = true,
              },
            },
          },
          -- Use a single tsserver for the workspace
          root_dir = function(fname)
            local util = require('lspconfig.util')
            return util.root_pattern('package.json', 'tsconfig.json', '.git')(fname) or util.path.dirname(fname)
          end,
          single_file_support = false,
        },

        -- Lua LSP with Neovim-specific settings
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }

      -- Tools to ensure are installed (formatters, linters, etc.)
      local ensure_installed_tools = {
        'stylua',     -- Lua formatter
        'prettier',   -- JavaScript/TypeScript/JSON/YAML formatter
        'eslint_d',   -- JavaScript/TypeScript linter
      }

      -- LSP servers to ensure are installed
      -- These will be automatically set up with default configs unless specified in 'servers' table
      local ensure_installed_lsps = {
        'ts_ls',                  -- TypeScript/JavaScript
        'lua_ls',                 -- Lua
        'jsonls',                 -- JSON
        'yamlls',                 -- YAML
        'dockerls',               -- Docker
        'prismals',               -- Prisma
        'kotlin_language_server', -- Kotlin
        'sqlls',                  -- SQL
      }

      -- Setup mason-tool-installer for formatters and linters
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed_tools,
      }

      -- Setup mason-lspconfig for automatic LSP installation and configuration
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed_lsps,
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local server_config = servers[server_name] or {}
            -- Merge capabilities
            server_config.capabilities = vim.tbl_deep_extend(
              'force',
              {},
              capabilities,
              server_config.capabilities or {}
            )
            -- Setup the server
            require('lspconfig')[server_name].setup(server_config)
          end,
        },
      }

      -- Create commands to manage TypeScript server memory
      vim.api.nvim_create_user_command('LspRestartTsServer', function()
        local clients = vim.lsp.get_clients({ name = 'ts_ls' })
        for _, client in ipairs(clients) do
          client.stop()
        end
        vim.cmd('edit') -- This will trigger LSP to restart
      end, { desc = 'Restart TypeScript Language Server' })

      vim.api.nvim_create_user_command('LspShowTsServerInfo', function()
        local clients = vim.lsp.get_clients({ name = 'ts_ls' })
        for _, client in ipairs(clients) do
          print(string.format('TypeScript Server PID: %s, Root: %s', client.pid or 'unknown', client.config.root_dir or 'unknown'))
        end
      end, { desc = 'Show TypeScript Server Info' })
    end,
  },
}