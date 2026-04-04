-- NOTE: <leader>ks behavior:
-- inside any Kulala buffer => reset scratchpad (delete old + create new in current window),
-- outside Kulala => reopen existing scratchpad if present, otherwise create one.
local function open_kulala_scratchpad()
  local function is_kulala_buffer(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.bo[buf].filetype
    return name:match '^kulala://' or filetype:match '%.kulala_ui$'
  end

  local scratchpads = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == 'kulala://scratchpad' then
      table.insert(scratchpads, buf)
    end
  end

  local current_buf = vim.api.nvim_get_current_buf()
  if is_kulala_buffer(current_buf) then
    for _, buf in ipairs(scratchpads) do
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
    require('kulala').scratchpad()
    return
  end

  if #scratchpads > 0 then
    local target = scratchpads[#scratchpads]
    for i = 1, #scratchpads - 1 do
      pcall(vim.api.nvim_buf_delete, scratchpads[i], { force = true })
    end
    vim.api.nvim_set_current_buf(target)
    return
  end

  require('kulala').scratchpad()
end

return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>k', '', desc = '+Rest' },
    { '<leader>ks', open_kulala_scratchpad, desc = 'Open scratchpad' },
    {
      '<leader>kg',
      "<cmd>lua require('kulala').download_graphql_schema()<cr>",
      desc = 'Download GraphQL schema',
      ft = 'http',
    },
    { '<leader>ki', "<cmd>lua require('kulala').inspect()<cr>", desc = 'Inspect current request', ft = 'http' },
    { '<leader>kq', "<cmd>lua require('kulala').close()<cr>", desc = 'Close window', ft = 'http' },
    { '<leader>kr', "<cmd>lua require('kulala').replay()<cr>", desc = 'Replay the last request', ft = 'http' },
    { '<leader>ke', "<cmd>lua require('kulala').run()<cr>", desc = 'Send the request', ft = 'http' },
    { '<leader>kS', "<cmd>lua require('kulala').show_stats()<cr>", desc = 'Show stats', ft = 'http' },
    { '<leader>kt', "<cmd>lua require('kulala').toggle_view()<cr>", desc = 'Toggle headers/body', ft = 'http' },
  },
  opts = {},
}
