return {
  {
    'nvim-mini/mini.move',
    opts = {
      mappings = {
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',
      },
    },
    config = function(_, opts)
      require('mini.move').setup(opts)
    end,
    event = 'VeryLazy',
  },
}
