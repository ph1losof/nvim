return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_check_bracket_line = false,
      enable_abbr = true,
      fast_wrap = {},
      disable_filetype = { 'snacks_picker_input', 'vim' },
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
    end,
  },
}
