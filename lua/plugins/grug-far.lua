return {
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { '<leader>sr', "<cmd>lua require('grug-far').open()<cr>", desc = 'S&R' },
      { '<leader>src', "<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<cr>", desc = 'S&R current word' },
    },
    config = function()
      require('grug-far').setup {}
    end,
  },
}
