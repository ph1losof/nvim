return {
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'saghen/blink.cmp',
    },
    opts = {},
    keys = {
      { '<leader>oi', '<cmd>TSToolsOrganizeImports<cr>', desc = 'Organize Imports' },
      { '<leader>ru', '<cmd>TSToolsRemoveUnused<cr>', desc = 'Remove unused statements' },
      { '<leader>ami', '<cmd>TSToolsAddMissingImports<cr>', desc = 'Add Missing Imports' },
    },
    config = function()
      local api = require 'typescript-tools.api'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

      require('typescript-tools').setup {
        capabilities = capabilities,
        root_dir = function(bufnr, on_dir)
          -- Don't attach in Deno projects
          if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) then
            return
          end
          local root = vim.fs.root(bufnr, { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' })
          if root then
            on_dir(root)
          end
        end,
        handlers = {
          -- NOTE: eslint handles 6133, 1109, 6192, 6196 (unused vars, imports, declarations)
          ['textDocument/publishDiagnostics'] = api.filter_diagnostics { 80006, 6133, 1109, 6192, 6196 },
        },
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { 'javascriptreact', 'typescriptreact' },
          },
          tsserver_plugins = {
            '@astrojs/ts-plugin',
          },
          tsserver_max_memory = 'auto',
        },
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        single_file_support = true,
        filetypes = {
          'typescript',
          'typescriptreact',
          'javascript',
          'javascriptreact',
        },
      }
    end,
  },
  {
    'dmmulroy/tsc.nvim',
    lazy = true,
    ft = { 'typescript', 'typescriptreact' },
    keys = { { '<leader>tc', '<cmd>TSC<cr>', desc = '[T]ypeScript [C]ompile' } },
    config = function()
      require('tsc').setup {
        use_trouble_qflist = true,
        auto_open_qflist = true,
        pretty_errors = false,
      }
    end,
  },
}
