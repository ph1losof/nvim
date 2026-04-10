return { {
  'kibi2/tirenvi.nvim',
  ft = { 'csv', 'tsv' },
  config = function()
    require('tirenvi').setup {}
  end,
} }
