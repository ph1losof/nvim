-- NOTE: currently oil.nvim is being loaded on startup to immediately open the parent directory,
-- this checks for specific conditions whether to load it or not.
-- Improved version based on snacks.dashboard and alpha.nvim patterns

-- stylua: ignore start
local function should_skip_oil()
  local buf = vim.api.nvim_get_current_buf()

  -- Handle directory argument - should OPEN oil for single directory arg
  if vim.fn.argc(-1) == 1 then
    local arg = vim.fn.argv(0) --[[@as string]]
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      return false -- Don't skip, open oil for directory
    end
  end

  -- Don't start when opening file(s)
  if vim.fn.argc(-1) > 0 then return true end

  -- Don't open if Neovim was invoked with a command (e.g., `nvim +SomeCommand`)
  if vim.api.nvim_buf_get_name(buf) ~= "" then return true end

  -- Do not open oil if the current buffer has any lines
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines > 1 or (#lines == 1 and #lines[1] > 0) then return true end

  -- Check for only one non-floating window
  local wins = vim.tbl_filter(function(win)
    local b = vim.api.nvim_win_get_buf(win)
    local config = vim.api.nvim_win_get_config(win)
    return config.relative == "" and vim.bo[b].buftype ~= "nofile"
  end, vim.api.nvim_list_wins())
  if #wins ~= 1 or vim.api.nvim_win_get_buf(wins[1]) ~= buf then
    return true
  end

  -- Skip when there are several listed buffers
  for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
    if buf_id ~= buf then
      local bufinfo = vim.fn.getbufinfo(buf_id)[1]
      if bufinfo and bufinfo.listed == 1 and #bufinfo.windows > 0 then
        return true
      end
    end
  end

  -- Don't open if buffer is modified
  if vim.bo[buf].modified then return true end

  -- Check for headless mode
  local uis = vim.api.nvim_list_uis()
  if #uis == 0 then return true end

  -- Don't open if stdin is piped (e.g., `echo "text" | nvim`)
  if uis[1].stdout_tty and not uis[1].stdin_tty then return true end

  -- Handle nvim -M
  if not vim.o.modifiable then return true end

  -- Check argv for specific flags
  ---@diagnostic disable-next-line: undefined-field
  for _, arg in pairs(vim.v.argv) do
    -- Whitelisted arguments - always open
    if arg == "--startuptime" then
      return false
    end
    -- Blacklisted arguments - always skip
    if arg == "-b"
      or arg == "-c" or vim.startswith(arg, "+")
      or arg == "-S"
    then
      return true
    end
  end

  -- Base case: don't skip
  return false
end
-- stylua: ignore end

-- NOTE: adds support for snacks rename feature in oil.nvim
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.err then
      return
    end
    for _, action in ipairs(event.data.actions) do
      if action.type == 'move' then
        local ok, snacks = pcall(require, 'snacks')
        if ok and snacks and snacks.rename then
          snacks.rename.on_rename_file(action.src, action.dest)
        end
      end
    end
  end,
})

return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<C-n>', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        delete_to_trash = true,
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
          end,
        },
      }

      if not should_skip_oil() then
        vim.schedule(function()
          require('oil').open()
        end)
      end
    end,
    lazy = false,
  },
}
