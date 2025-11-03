return {
  {
    'ph1losof/morta.nvim',
    branch = '2.0',
    name = 'morta',
    priority = 1000,
    opts = {},
    config = function()
      local ok = pcall(vim.cmd.colorscheme, 'morta')
      if not ok then
        vim.notify('Failed to load morta colorscheme, using default', vim.log.levels.WARN)
      end
    end,
  },
}
