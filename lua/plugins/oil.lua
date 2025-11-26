-- NOTE: currently oil.nvim is being loaded on startup to immediately open the parent directory,
-- this checks for specific conditions whether to load it or not.
-- Improved version based on snacks.dashboard and alpha.nvim patterns
-- Optimized to prevent flash and improve startup performance

local api = vim.api
local fn = vim.fn
local bo = vim.bo

-- stylua: ignore start
local function should_skip_oil()
  -- PERF: Early return checks first (fastest operations)
  local argc = fn.argc(-1)

  -- Handle directory argument - should OPEN oil for single directory arg
  if argc == 1 then
    local arg = fn.argv(0) --[[@as string]]
    if arg ~= "" and fn.isdirectory(arg) == 1 then
      return false -- Don't skip, open oil for directory
    end
  end

  -- Don't start when opening file(s)
  if argc > 0 then return true end

  local buf = api.nvim_get_current_buf()

  -- Don't open if Neovim was invoked with a command (e.g., `nvim +SomeCommand`)
  if api.nvim_buf_get_name(buf) ~= "" then return true end

  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines > 1 or (#lines == 1 and #lines[1] > 0) then return true end

  if bo[buf].modified then return true end

  -- Check for headless mode early
  local uis = api.nvim_list_uis()
  if #uis == 0 then return true end

  -- Don't open if stdin is piped (e.g., `echo "text" | nvim`)
  if uis[1].stdout_tty and not uis[1].stdin_tty then return true end

  -- Handle nvim -M
  if not vim.o.modifiable then return true end

  ---@diagnostic disable-next-line: undefined-field
  for _, arg in pairs(vim.v.argv) do
    if arg == "--startuptime" then return false end
    if arg == "-b" or arg == "-c" or arg == "-S" or vim.startswith(arg, "+") then
      return true
    end
  end

  local win_count = 0
  local valid_win
  for _, win in ipairs(api.nvim_list_wins()) do
    local b = api.nvim_win_get_buf(win)
    if api.nvim_win_get_config(win).relative == "" and bo[b].buftype ~= "nofile" then
      win_count = win_count + 1
      valid_win = win
      if win_count > 1 then return true end -- Early exit if multiple windows
    end
  end

  if win_count ~= 1 or api.nvim_win_get_buf(valid_win) ~= buf then
    return true
  end

  -- Skip when there are several listed buffers
  for _, buf_id in pairs(api.nvim_list_bufs()) do
    if buf_id ~= buf then
      local bufinfo = fn.getbufinfo(buf_id)[1]
      if bufinfo and bufinfo.listed == 1 and #bufinfo.windows > 0 then
        return true
      end
    end
  end

  -- Base case: don't skip
  return false
end
-- stylua: ignore end

-- NOTE: adds support for snacks rename feature in oil.nvim
api.nvim_create_autocmd('User', {
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
    init = function()
      -- PERF: Pre-check and hide UI elements before plugin loads
      if not should_skip_oil() then
        -- Cache original values
        local showtabline = vim.o.showtabline
        local laststatus = vim.o.laststatus

        -- Hide UI elements immediately
        vim.o.shortmess = vim.o.shortmess .. 'I' -- Disable intro message
        vim.o.showtabline = 0
        vim.o.laststatus = 0

        -- Restore on first BufEnter (when Oil buffer loads)
        api.nvim_create_autocmd('BufEnter', {
          once = true,
          callback = function()
            vim.o.showtabline = showtabline
            vim.o.laststatus = laststatus
          end,
        })
      end
    end,
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
        require('oil').open()
      end
    end,
    lazy = false,
    priority = 500,
  },
}
