-- NOTE: sets shiftwidth for DBUI buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dbui',
  callback = function()
    vim.bo.shiftwidth = 2
  end,
  desc = 'Set shiftwidth for DBUI buffers',
})

return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_win_position = 'right'
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
