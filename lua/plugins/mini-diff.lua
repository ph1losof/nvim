return {
  'echasnovski/mini.diff',
  config = function()
    local diff = require 'mini.diff'
    diff.setup {
      -- NOTE: Disabled by default currently used only for codecompanion.nvim
      source = diff.gen_source.none(),
    }
  end,
}
