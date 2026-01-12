return {
  'ph1losof/shelter.nvim',
  keys = {
    { '<leader>st', '<cmd>Shelter toggle<cr>', desc = 'Toggle masking' },
  },
  opts = {
    skip_comments = false,
    default_mode = 'partial',
    modules = {
      files = true,
      snacks_previewer = true,
    },
  },
}
