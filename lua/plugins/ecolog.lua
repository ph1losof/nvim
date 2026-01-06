-- NOTE: Im in the process of switching to https://github.com/ph1losof/ecolog-lsp soon will make a neovim plugin for this lsp

return {}
--[[ -- WARN: Check if local development directory exists, fallback to official repo. Can be removed, but required for my workflow
local local_ecolog = vim.fn.expand '~/Projects/ecolog.nvim'
local use_local = vim.uv.fs_stat(local_ecolog) ~= nil

local ecolog_spec = {
  [use_local and 'dir' or 'url'] = use_local and local_ecolog or 'https://github.com/ph1losof/ecolog.nvim',
  keys = {
    { '<leader>e', '', desc = '+ecolog', mode = { 'n', 'v' } },
    { '<leader>el', '<Cmd>EcologShelterLinePeek<cr>', desc = 'Peek line' },
    { '<leader>ey', '<Cmd>EcologCopy<cr>', desc = 'Copy value under cursor' },
    { '<leader>ei', '<Cmd>EcologInterpolationToggle<cr>', desc = 'Toggle interpolation' },
    { '<leader>eh', '<Cmd>EcologShellToggle<cr>', desc = 'Toggle shell variables' },
    { '<leader>ge', '<cmd>EcologGoto<cr>', desc = 'Go to env file' },
    { '<leader>ec', '<cmd>EcologSnacks<cr>', desc = 'Open a picker' },
    { '<leader>eS', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
    { '<leader>es', '<cmd>EcologShelterToggle<cr>', desc = 'Shelter toggle' },
  },
  opts = {
    preferred_environment = 'local',
    vim_env = true,
    types = true,
    monorepo = {
      enabled = true,
      auto_switch = true,
      notify_on_switch = false,
    },
    interpolation = {
      enabled = true,
      features = {
        commands = false,
      },
    },
    sort_var_fn = function(a, b)
      if a.source == 'shell' and b.source ~= 'shell' then
        return false
      end
      if a.source ~= 'shell' and b.source == 'shell' then
        return true
      end

      return a.name < b.name
    end,
    integrations = {
      lspsaga = true,
      blink_cmp = true,
      snacks = true,
      statusline = {
        hidden_mode = true,
        icons = { enabled = true, env = 'E', shelter = 'S' },
        highlights = {
          env_file = 'Directory',
          vars_count = 'Number',
        },
      },
    },
    shelter = {
      configuration = {
        patterns = {
          ['DATABASE_URL'] = 'full',
        },
        sources = {
          ['.env.example'] = 'none',
        },
        skip_comments = false,
        partial_mode = {
          min_mask = 5,
          show_start = 1,
          show_end = 1,
        },
        mask_char = '*',
      },
      modules = {
        files = true,
        peek = false,
        snacks_previewer = true,
        snacks = false,
        cmp = true,
      },
    },
    path = vim.fn.getcwd(),
  },
}

return { ecolog_spec } ]]
