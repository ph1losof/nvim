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
    build = ':TSUpdate',
    dependencies = { 'windwp/nvim-ts-autotag' },
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
        'bash',
        'cmake',
        'css',
        'dockerfile',
        'dot',
        'git_rebase',
        'astro',
        'gitattributes',
        'prisma',
        'gitcommit',
        'gitignore',
        'html',
        'graphql',
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
        'python',
        'regex',
        'rust',
        'sql',
        'comment',
        'sxhkdrc',
        'todotxt',
        'toml',
        'typescript',
        'svelte',
        'tsx',
        'vim',
        'vimdoc',
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
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
