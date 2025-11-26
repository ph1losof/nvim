return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettier', 'prettierd', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        less = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        python = { 'ruff_format', 'ruff' },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        astro = { 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        ['markdown.mdx'] = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'prettierd', 'prettier', stop_after_first = true },
        handlebars = { 'prettierd', 'prettier', stop_after_first = true },
      },
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 3000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      default_format_opts = {
        timeout_ms = 3000,
        async = true,
        quiet = false,
        lsp_format = 'fallback',
      },
    },
  },
  {
    'Wansmer/treesj',
    opts = { use_default_keymaps = false },
    cmd = {
      'TSJToggle',
      'TSJJoin',
      'TSJSplit',
    },
    keys = {
      {
        '<leader>m',
        '<CMD>TSJToggle<CR>',
        {
          desc = 'Toggle TreeSitter join/split',
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
