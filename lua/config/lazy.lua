local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to clone lazy.nvim:\n' .. output, vim.log.levels.ERROR)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'netrwPlugin',
        'tutor',
      },
    },
  },
})
