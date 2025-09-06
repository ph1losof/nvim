return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {},
      image = {},
      bigfile = { enabled = true },
      scope = { enabled = true },
      dashboard = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        '<leader>fw',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files { hidden = true, exclude = { 'node_modules' } }
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Find Commands',
      },
      {
        '<leader>fco',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Config File',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle Zen Mode',
      },
      {
        '<leader>Z',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle Zoom',
      },
      {
        '<leader>ns',
        function()
          Snacks.picker.notifications()
        end,
        desc = 'Notification Picker',
      },
      {
        '<leader>n',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>lf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>lg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
      -- lsp stuff
      {
        '<leader>gD',
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = 'Goto Declaration',
      },
      {
        '<leader>gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        '<leader>gI',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        '<leader>gt',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto [T]ype Definition',
      },
      -- symbols
      {
        '<leader>fsd',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Document Symbols',
      },
      {
        '<leader>fsw',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
    },
    init = function()
      require('snacks').util.set_hl({
        Totals = 'Comment',
        Dir = 'Comment',
      }, { prefix = 'SnacksPicker' })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>sp'
          Snacks.toggle.dim():map '<leader>dim'
        end,
      })
    end,
  },
  {
    'DestopLine/scratch-runner.nvim',
    dependencies = 'folke/snacks.nvim',
    opts = {
      sources = {
        javascript = { 'node' },
        typescript = {
          'deno',
        },
      },
    },
  },
}
