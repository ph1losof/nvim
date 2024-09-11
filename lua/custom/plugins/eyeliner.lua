return {
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require('eyeliner').setup {
        highlight_on_key = true,
        default_keymaps = true,
      }
      vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = '#ffffff', bold = true, underline = true })
    end,

    event = 'VeryLazy',
  },
}
