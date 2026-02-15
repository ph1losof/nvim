return {
  'ph1losof/shelter.nvim',
  lazy = false,
  keys = {
    { '<leader>st', '<cmd>Shelter toggle<cr>', desc = 'Toggle masking' },
    { '<leader>stp', '<cmd>Shelter peek<cr>', desc = 'Toggle masking on a line' },
  },
  opts = {
    skip_comments = false,
    modules = {
      ecolog = {
        cmp = true, -- Mask completion
        peek = false, -- Mask hover
        picker = false,
      },
      files = true,
      snacks_previewer = true,
    },
  },
}
