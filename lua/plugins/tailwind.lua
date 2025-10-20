return {
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      { 'neovim/nvim-lspconfig', version = 'v2.4.0' },
    },
    opts = {
      document_color = { enabled = false },
    },
  },
}
