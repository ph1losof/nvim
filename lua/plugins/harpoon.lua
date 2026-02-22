return {
  {
    'ThePrimeagen/harpoon',
    enabled = true,
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      {
        '<leader>h1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Go to harpoon mark 1',
      },
      {
        '<leader>h2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Go to harpoon mark 2',
      },
      {
        '<leader>h3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Go to harpoon mark 3',
      },
      {
        '<leader>h4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Go to harpoon mark 4',
      },
      {
        '<leader>hm',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Show harpoon marks',
      },
      {
        '<leader>ha',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Add buffer to harpoon',
      },
    },
    config = function(_, opts)
      require('harpoon').setup(opts)
    end,
  },
}
