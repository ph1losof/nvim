return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>k', '', desc = '+Rest' },
    { '<leader>ks', "<cmd>lua require('kulala').scratchpad()<cr>", desc = 'Open scratchpad' },
    {
      '<leader>kg',
      "<cmd>lua require('kulala').download_graphql_schema()<cr>",
      desc = 'Download GraphQL schema',
      ft = 'http',
    },
    { '<leader>ki', "<cmd>lua require('kulala').inspect()<cr>", desc = 'Inspect current request', ft = 'http' },
    { '<leader>kq', "<cmd>lua require('kulala').close()<cr>", desc = 'Close window', ft = 'http' },
    { '<leader>kr', "<cmd>lua require('kulala').replay()<cr>", desc = 'Replay the last request', ft = 'http' },
    { '<leader>ke', "<cmd>lua require('kulala').run()<cr>", desc = 'Send the request', ft = 'http' },
    { '<leader>kS', "<cmd>lua require('kulala').show_stats()<cr>", desc = 'Show stats', ft = 'http' },
    { '<leader>kt', "<cmd>lua require('kulala').toggle_view()<cr>", desc = 'Toggle headers/body', ft = 'http' },
  },
  opts = {},
}
