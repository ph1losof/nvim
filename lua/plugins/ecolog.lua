return {
  {
    'ph1losof/ecolog2.nvim',
    build = 'cargo install ecolog-lsp',
    keys = {
      { '<leader>ef', '<cmd>Ecolog files<cr>', desc = 'Ecolog toggle file module' },
      { '<leader>ev', '<cmd>Ecolog copy value<cr>', desc = 'Ecolog copy value' },
      { '<leader>ege', '<cmd>Ecolog generate .env.example<cr>', desc = 'Ecolog generate .env.example' },
      { '<leader>eg', '<cmd>Ecolog generate<cr>', desc = 'Ecolog generate' },
      { '<leader>es', '<cmd>Ecolog files select<cr>', desc = 'Ecolog select active file' },
      { '<leader>ei', '<cmd>Ecolog interpolation<cr>', desc = 'Ecolog toggle interpolation' },
      { '<leader>el', '<cmd>Ecolog list<cr>', desc = 'Ecolog list variables' },
      { '<leader>ge', '<cmd>Ecolog files open_active<cr>', desc = 'Go to active ecolog file' },
      { '<leader>eh', '<cmd>Ecolog shell<cr>', desc = 'Ecolog toggle shell module' },
    },
    config = function()
      require('ecolog').setup {
        vim_env = true,
        statusline = {
          sources = {
            enabled = true,
            show_disabled = true,
          },
          interpolation = {
            show_disabled = false,
          },
          highlights = {
            sources = 'String',
            sources_disabled = 'Comment',
            env_file = 'Directory',
            vars_count = 'Number',
          },
        },
        sort_var_fn = function(a, b)
          local a_is_shell = a.source == 'System Environment'
          local b_is_shell = b.source == 'System Environment'

          if a_is_shell and not b_is_shell then
            return false
          end
          if not a_is_shell and b_is_shell then
            return true
          end

          return a.name < b.name
        end,
        lsp = {
          sources = {
            defaults = {
              shell = false,
              file = true,
            },
          },
          init_options = {
            interpolation = {
              enabled = false,
            },
          },
        },
      }
    end,
  },
}
