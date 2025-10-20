return {
  'vuki656/package-info.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  -- NOTE: better then ft
  event = {
    'BufRead package.json',
    'BufNewFile package.json',
    'BufWinEnter package.json',
  },
  keys = {
    { '<leader>nc', "<cmd>lua require('package-info').change_version()<cr>", desc = 'Package Info' },
    { '<leader>nd', "<cmd>lua require('package-info').delete()<cr>", desc = 'Package Info' },
    { '<leader>ni', "<cmd>lua require('package-info').install()<cr>", desc = 'Package Info' },
  },
  opts = {
    highlights = {
      up_to_date = { fg = '#7F86A6' },
      outdated = { fg = '#E6AC5E' },
      invalid = { fg = '#FF6590' },
    },
    autostart = true,
  },
  config = function(_, opts)
    -- NOTE: makes it so that it validates that package.json in the valid format before loading package-info.nvim
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines > 0 then
      local content = table.concat(lines, '\n')
      local ok, parsed = pcall(vim.fn.json_decode, content)

      if ok and type(parsed) == 'table' then
        if parsed.name or parsed.dependencies or parsed.devDependencies or parsed.scripts then
          require('package-info').setup(opts)
        end
      end
    end
  end,
}
