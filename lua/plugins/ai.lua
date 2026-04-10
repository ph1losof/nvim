return {
  {
    'ThePrimeagen/99',
    event = 'VeryLazy',
    dependencies = {
      'saghen/blink.compat',
    },
    keys = {
      {
        '<leader>aa',
        function()
          require('99').vibe {}
        end,
        desc = '99 Vibe',
        mode = 'n',
      },
      {
        '<leader>av',
        function()
          require('99').visual {}
        end,
        desc = '99 Visual',
        mode = 'v',
      },
      {
        '<leader>as',
        function()
          require('99').search {}
        end,
        desc = '99 Search',
        mode = 'n',
      },
      {
        '<leader>ax',
        function()
          require('99').stop_all_requests()
        end,
        desc = '99 Stop Requests',
        mode = 'n',
      },
      {
        '<leader>al',
        function()
          require('99').view_logs()
        end,
        desc = '99 View Logs',
        mode = 'n',
      },
    },
    config = function()
      local _99 = require '99'

      _99.setup {
        provider = _99.Providers.OpenCodeProvider,
        model = 'openai/gpt-5.3-codex',
        provider_extra_args = {
          '--dangerously-skip-permissions',
        },
        tmp_dir = './99_tmp/',
        md_files = { 'AGENTS.md', 'AGENT.md' },
        logger = {
          level = _99.DEBUG,
          path = '/tmp/99.debug.log',
          print_on_error = true,
        },
        display_errors = true,
        completion = {
          source = 'blink',
          custom_rules = {},
          files = {},
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
