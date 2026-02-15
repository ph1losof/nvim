return {
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<leader><tab>',
          node_incremental = '<leader><tab>',
          node_decremental = '<bs>',
          scope_incremental = false,
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- jsonc uses the json parser (jsonc was removed from nvim-treesitter main)
      vim.treesitter.language.register('json', 'jsonc')

      -- Register custom edf parser for .env files via User TSUpdate autocmd
      -- (official mechanism for custom parsers on the main branch)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          require('nvim-treesitter.parsers').edf = {
            install_info = {
              url = 'https://github.com/ph1losof/tree-sitter-edf',
              branch = 'main',
            },
          }
        end,
      })
      vim.treesitter.language.register('edf', 'edf')

      -- Auto-install edf highlight queries if missing
      local queries_dir = vim.fn.stdpath 'config' .. '/queries/edf'
      local highlights_file = queries_dir .. '/highlights.scm'
      if vim.fn.filereadable(highlights_file) == 0 then
        vim.fn.mkdir(queries_dir, 'p')
        vim.fn.jobstart({
          'curl',
          '-sL',
          'https://raw.githubusercontent.com/ph1losof/tree-sitter-edf/main/queries/highlights.scm',
          '-o',
          highlights_file,
        }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify('edf highlight queries installed', vim.log.levels.INFO)
            end
          end,
        })
      end

      -- Install parsers (deferred to avoid TSUpdate nesting during startup)
      vim.schedule(function()
        require('nvim-treesitter').install {
          'astro',
          'bash',
          'cmake',
          'comment',
          'css',
          'diff',
          'dockerfile',
          'dot',
          'edf',
          'git_rebase',
          'gitattributes',
          'gitcommit',
          'gitignore',
          'go',
          'graphql',
          'hcl',
          'html',
          'http',
          'javascript',
          'jq',
          'json',
          'json5',
          'lua',
          'make',
          'markdown',
          'markdown_inline',
          'nix',
          'prisma',
          'python',
          'regex',
          'rust',
          'sql',
          'svelte',
          'sxhkdrc',
          'terraform',
          'todotxt',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
          'yaml',
        }
      end)

      -- Enable treesitter features via FileType autocmd
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-features', { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local ft = vim.bo[bufnr].filetype

          if pcall(vim.treesitter.start, bufnr) then
            -- Enable indentation (skip ruby)
            if ft ~= 'ruby' then
              vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          -- Ruby needs vim regex highlighting alongside treesitter
          if ft == 'ruby' then
            vim.bo[bufnr].syntax = 'ruby'
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
