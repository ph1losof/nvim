return {
  {
    'windwp/nvim-ts-autotag',

    lazy = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    commit = '42fc28ba918343ebfd5565147a42a26580579482',
    build = ':TSUpdate',
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
      ensure_installed = {
        'astro',
        'bash',
        'cmake',
        'comment',
        'css',
        'diff',
        'dockerfile',
        'dot',
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
        'jsonc',
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
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true

      -- Register custom edf parser for .env files
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.edf = {
        install_info = {
          url = 'https://github.com/ph1losof/tree-sitter-edf',
          files = { 'src/parser.c', 'src/scanner.c' },
          branch = 'main',
        },
        filetype = 'edf',
      }

      -- Auto-install edf highlight queries if missing
      local queries_dir = vim.fn.stdpath('config') .. '/queries/edf'
      local highlights_file = queries_dir .. '/highlights.scm'
      if vim.fn.filereadable(highlights_file) == 0 then
        vim.fn.mkdir(queries_dir, 'p')
        vim.fn.jobstart({
          'curl', '-sL',
          'https://raw.githubusercontent.com/ph1losof/tree-sitter-edf/main/queries/highlights.scm',
          '-o', highlights_file,
        }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify('edf highlight queries installed', vim.log.levels.INFO)
            end
          end,
        })
      end

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
