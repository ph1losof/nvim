return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
        config = true,
      }, -- NOTE: Must be loaded before dependants
      { 'mason-org/mason-lspconfig.nvim' },
      -- NOTE: installing not using mason solves https://github.com/nanotee/sqls.nvim/issues/23
      { 'nanotee/sqls.nvim' },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
          'williamboman/mason.nvim',
        },
        opts = {
          ensure_installed = {
            'prettier',
            'ruff',
            'stylua',
            'isort',
            'black',
            'pylint',
            'eslint_d',
          },
        },
      },
      { 'j-hui/fidget.nvim', opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      } },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      'saghen/blink.cmp',
    },
    config = function()
      local helpers = require 'helpers'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

      local servers = {
        ecolog_lsp = {
          cmd = { '/Users/tentacles/Projects/ecolog/target/release/ecolog-lsp' },
          filetypes = { 'javascript', 'typescript', 'python', 'rust', 'go', 'ruby', 'php', 'lua', 'dotenv' },
          capabilities = capabilities,
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { '.ecolog.toml', 'package.json', 'Cargo.toml', '.git' })
            if root then
              on_dir(root)
            end
          end,
        },
        html = {},
        cssls = {},
        astro = {},
        pyright = {
          settings = {
            analysis = { typeCheckingMode = 'strict', autoImportCompletions = true, autoSearchPaths = true, useLibraryCodeForTypes = true },
          },
        },
        ruff = {
          init_options = {
            settings = {
              organizeImports = true,
            },
          },
        },
        eslint = {},
        denols = {
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
            if root then
              on_dir(root)
            end
          end,
        },
        bashls = {
          handlers = {
            ['textDocument/publishDiagnostics'] = function(err, res, ...)
              local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ':t')
              if string.match(file_name, '^%.env') == nil then
                return vim.lsp.diagnostic.on_publish_diagnostics(err, res, ...)
              end
            end,
          },
        },
        tailwindcss = {
          hovers = true,
          suggestions = true,
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { 'tailwind.config.cjs', 'tailwind.config.ts', 'tailwind.config.mjs', 'tailwind.config.js', 'postcss.config.js' })
            if root then
              on_dir(root)
            end
          end,
        },
        marksman = {
          -- NOTE: This solves the problem of Marksman exiting when a new hover doc buffer (from Lspsaga) is created credits to FlawlessCasual17
          ---@param bufnr number
          autostart = function(bufnr)
            if helpers.is_lspsaga_peek_window(bufnr) then
              return false
            end
            return true
          end,
          ---@param bufnr number
          enable = function(bufnr)
            if helpers.is_lspsaga_peek_window(bufnr) then
              return false
            end
            return true
          end,
        },
        sqls = {},
        rust_analyzer = {
          file_types = { 'rust' },
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { 'Cargo.toml', 'Makefile' })
            if root then
              on_dir(root)
            end
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = {}
      vim.list_extend(ensure_installed, {
        -- Lua
        'lua-language-server',
        'prisma-language-server',
        'luacheck',
        'stylua',

        -- Python
        'pyright',

        -- SQL
        'sqlfluff',
        'sql-formatter',

        -- Rust
        'rust-analyzer',
        'rustfmt',

        -- File Formats
        'json-lsp',
        'jsonlint',
        'jq',
        'yaml-language-server',
        'yamllint',
        'yamlfmt',

        -- Git
        'commitlint',
        'gitlint',

        -- Writing
        'marksman',
        'markdownlint',
        'vale',
        'write-good',
        'cspell',
        'misspell',
        'proselint',

        -- Shell
        'bash-language-server',
        'beautysh',
        'shfmt',
        'shellcheck',
        'shellharden',

        -- Others
        'tailwindcss-language-server',
        'css-lsp',
        'prettierd',
        'vue-language-server',
        'eslint_d',
        'codespell',
        'dockerfile-language-server',
        'dot-language-server',
        'editorconfig-checker',
        'html-lsp',
        'astro-language-server',
        'deno',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      vim.api.nvim_create_user_command('MasonInstallAll', function()
        vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
      end, {})

      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      vim.lsp.config('ecolog_lsp', {
        cmd = { '/Users/tentacles/Projects/ecolog/target/release/ecolog-lsp' },
        filetypes = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'python', 'rust', 'go', 'ruby', 'php', 'lua', 'sh' },
        root_markers = { '.ecolog.toml', 'package.json', 'Cargo.toml', '.git' },
      })

      for server_name, config in pairs(servers) do
        local server_config = vim.tbl_deep_extend('force', {}, config)
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.config(server_name, server_config)
      end

      require('mason-lspconfig').setup {
        ensure_installed = {},
      }

      local server_names = vim.tbl_keys(servers)
      vim.lsp.enable(server_names)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
