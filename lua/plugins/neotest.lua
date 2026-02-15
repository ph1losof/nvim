return {
  { 'nvim-neotest/neotest-plenary' },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-plenary',
      {
        'vhyrro/luarocks.nvim',
        opts = {
          rocks = { 'lua-curl', 'inspect', 'nvim-nio', 'mimetypes', 'xml2lua' },
        },
      },
      'arthur944/neotest-bun',
    },
    opts = {
      adapters = {
        'neotest-plenary',
        'neotest-bun',
      },
      status = { virtual_text = true },
      output = { open_on_run = false },
      quickfix = {
        enabled = false,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      opts.consumers = opts.consumers or {}

      -- Refresh and auto close trouble after running tests
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))

          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == 'failed' and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require 'trouble'
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
          return {}
        end
      end

      opts.consumers.timber = require('timber.watcher.sources.neotest').consumer

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
  -- stylua: ignore
  keys = {
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
    { "<leader>tfg", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
    { "<leader>tfn", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
    { "<leader>tfl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
    { "<leader>tfs", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
    { "<leader>tfo", function()
      require("neotest").output.open({ enter = true, auto_close = true })
    end, desc = "Show Output (Neotest)" },
    { "<leader>tfO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
    { "<leader>tfS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
    { "<leader>tfw", function()
      require("neotest").watch.toggle(vim.fn.expand("%"))
    end, desc = "Toggle Watch (Neotest)" },
  },
  },
}
