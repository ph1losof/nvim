return {
  {
    'kevinhwang91/nvim-bqf',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('bqf').setup {
        ---@diagnostic disable-next-line: missing-fields
        preview = {
          winblend = 0,
        },
      }
    end,
  },
}
