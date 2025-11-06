return {
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      document_color = { enabled = false },
      server = {
        override = false, -- Disable auto-setup since we configure tailwindcss LSP manually
      },
    },
  },
}
