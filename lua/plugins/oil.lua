-- NOTE: currently oil.nvim is being loaded on startup to immdiately open the parent directory,
-- this checks for specific conditions whether to load it or not. The following piece of code is taken from dashboard plugin - alpha.nvim
-- taken from https://github.com/goolord/alpha-nvim/blob/b6f4129302db197a7249e67a90de3f2b676de13e/lua/alpha.lua#L570

-- stylua: ignore start
local function should_skip_oil()
    -- don't start when opening a file
    if vim.fn.argc() > 0 then return true end

    -- Do not open oil if the current buffer has any lines (something opened explicitly).
    local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
    if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then return true end

    -- Skip when there are several listed buffers.
    for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(buf_id)
        if bufinfo.listed == 1 and #bufinfo.windows > 0
            then return true
        end
    end

    -- Handle nvim -M
    if not vim.o.modifiable then return true end

    ---@diagnostic disable-next-line: undefined-field
    for _, arg in pairs(vim.v.argv) do
        -- whitelisted arguments
        -- always open
        if arg == "--startuptime"
        then return false
        end

        -- blacklisted arguments
        -- always skip
        if arg == "-b"
            -- commands, typically used for scripting
            or arg == "-c" or vim.startswith(arg, "+")
            or arg == "-S"
        then return true
        end
    end

    -- base case: don't skip
    return false
end
-- stylua: ignore end

-- NOTE: adds support for snacks rename feature in oil.nvim
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
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

      if should_skip_oil() == false then
        vim.cmd 'Oil'
      end
    end,
    lazy = false,
  },
}
