return {
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    lazy = false,
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  {
    'Goose97/timber.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>glc',
        function()
          require('timber.actions').toggle_comment_log_statements { global = false }
        end,
        desc = 'Toggle Comment Log Statements',
      },
      {
        '<leader>glj',
        function()
          require('timber.actions').insert_log { position = 'below' }
        end,
        desc = 'Insert Log Below',
      },
      {
        '<leader>glk',
        function()
          require('timber.actions').insert_log { position = 'above' }
        end,
        desc = 'Insert Log Above',
      },
      {
        '<leader>gld',
        function()
          require('timber.actions').clear_log_statements { global = true }
        end,
        desc = 'Delete Log statements',
      },
      {
        '<leader>glw',
        function()
          require('timber.actions').insert_log { template = 'watcher', position = 'below' }
        end,
        desc = 'Insert Watcher Log Statement',
      },
    },
    config = function()
      require('timber').setup {
        log_templates = {
          watcher = {
            javascript = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            typescript = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            jsx = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
            tsx = [[console.log('%watcher_marker_start', %log_target, '%watcher_marker_end')]],
          },
        },
        log_watcher = {
          enabled = true,
          sources = {
            ts = {
              type = 'filesystem',
              name = 'Log file',
              path = '/tmp/metro.log',
            },
          },
          preview_snippet_length = 32,
        },
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
    },
    opts = { signs = false },
  },
}
