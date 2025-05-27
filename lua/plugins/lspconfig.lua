return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', tag = 'v1.11.0', config = true }, -- NOTE: Must be loaded before dependants
      { 'mason-org/mason-lspconfig.nvim', tag = 'v1.32.0' },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
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
      local util = require 'lspconfig/util'

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics

      local servers = {
        html = {},
        cssls = {},
        astro = {},
        eslint = {},
        denols = {
          root_dir = function(fname)
            local root_pattern = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc')
            return root_pattern(fname)
          end,
        },
        bashls = {
          handlers = {
            ['textDocument/publishDiagnostics'] = function(err, res, ...)
              local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ':t')
              if string.match(file_name, '^%.env') == nil then
                return on_publish_diagnostics(err, res, ...)
              end
            end,
          },
        },
        tailwindcss = {
          hovers = true,
          suggestions = true,
          root_dir = function(fname)
            local root_pattern = require('lspconfig').util.root_pattern(
              'tailwind.config.cjs',
              'tailwind.config.ts',
              'tailwind.config.mjs',
              'tailwind.config.js',
              'postcss.config.js'
            )
            return root_pattern(fname)
          end,
        },
        marksman = {
          -- This solves the problem of Marksman exiting when a new hover doc buffer (from Lspsaga) is created credits to FlawlessCasual17
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
        emmet_language_server = {
          {
            filetypes = {
              'astro',
              'css',
              'eruby',
              'html',
              'javascript',
              'javascriptreact',
              'less',
              'php',
              'pug',
              'sass',
              'scss',
              'typescriptreact',
            },
            init_options = {
              --- @type string[]
              excludeLanguages = {},
              --- @type string[]
              extensionsPath = {},
              --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
              preferences = {},
              --- @type boolean Defaults to `true`
              showAbbreviationSuggestions = true,
              --- @type "always" | "never" Defaults to `"always"`
              showExpandedAbbreviation = 'always',
              --- @type boolean Defaults to `false`
              showSuggestionsAsSnippets = false,
              --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
              syntaxProfiles = {},
              --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
              variables = {},
            },
          },
        },
        rust_analyzer = {
          file_types = { 'rust' },
          root_dir = util.root_pattern 'Config.toml',
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

        -- SQL
        'sqls',
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
        'emmet-language-server',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      vim.api.nvim_create_user_command('MasonInstallAll', function()
        vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
      end, {})

      require('mason-lspconfig').setup {
        automatic_installation = false,
        ensure_installed = {},
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
