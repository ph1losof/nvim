return {
  {
    'windwp/nvim-autopairs',
    opts = {
      fast_wrap = {},
      disable_filetype = { 'snacks_picker_input', 'vim' },
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
    end,
  },
}
