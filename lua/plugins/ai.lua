return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
        -- copilot_model = 'gpt-4o-copilot',
      }
    end,
  },
  {
    'greggh/claude-code.nvim',
    keys = {
      {
        '<leader>aa',
        '<cmd>ClaudeCode<CR>',
        { desc = 'Toggle Claude Code' },
      },
      {
        '<leader>ac',
        '<cmd>ClaudeCodeContinue<CR>',
        { desc = 'Resume recent Claude Code' },
      },
      {
        '<leader>ar',
        '<cmd>ClaudeCodeResume<CR>',
        { desc = 'Conversation picker Claude Code' },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('claude-code').setup()
    end,
  },
}
