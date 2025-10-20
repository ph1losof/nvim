return { {
  'nvim-mini/mini.bracketed',
  config = function()
    require('mini.bracketed').setup()
  end,
  event = 'VeryLazy',
} }
