return {
  {
    't3ntxcl3s/morta.nvim',
    branch = '2.0',
    name = 'morta',
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme 'morta'
    end,
  },
}
