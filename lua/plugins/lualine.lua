local harpoon_section = {
  'harpoon2',
  icon = '󰛢',
  indicators = { '1', '2', '3', '4' },
  active_indicators = { '[1]', '[2]', '[3]', '[4]' },
  color_active = { fg = '#D0A8E5' },
  _separator = ' ',
  no_harpoon = 'Harpoon not loaded',
}

-- NOTE: instead of using default oil extension we use custom to include
-- harpoon line for easier navigation when opening oil
local oil_extension = {
  sections = {
    lualine_a = {
      function()
        local ok, oil = pcall(require, 'oil')
        if ok and oil and oil.get_current_dir then
          return vim.fn.fnamemodify(oil.get_current_dir() or '', ':~')
        else
          return ''
        end
      end,
    },
    lualine_c = {
      harpoon_section,
    },
  },
  filetypes = { 'oil' },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          globalstatus = true,
        },
        extensions = {
          'lazy',
          'quickfix',
          oil_extension,
          'trouble',
        },
        sections = {
          lualine_c = {
            'filename',
            harpoon_section,
          },
          lualine_x = {
            require('ecolog.statusline.lualine').create {},
          },
          lualine_y = {
            'encoding',
            'fileformat',
            'filetype',
          },
        },
      }
    end,
  },
  {
    'letieu/harpoon-lualine',
    dependencies = {
      {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
      },
    },
  },
}
