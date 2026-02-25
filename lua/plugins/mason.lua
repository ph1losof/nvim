return {
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },
  { 'mason-org/mason-lspconfig.nvim' },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    config = function()
      local ensure_installed = {}
      vim.list_extend(ensure_installed, {
        -- Lua
        'lua-language-server',
        'prisma-language-server',
        'luacheck',
        'stylua',

        -- Python
        'pyright',
        'ruff',
        'isort',
        'black',
        'pylint',

        -- SQL
        'sqlfluff',
        'sql-formatter',

        -- Rust
        'rust-analyzer',
        'rustfmt',
        'taplo',

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

        -- Biome
        'biome',

        -- Others
        'tailwindcss-language-server',
        'css-lsp',
        'prettier',
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

      require('mason-lspconfig').setup {
        ensure_installed = {},
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
