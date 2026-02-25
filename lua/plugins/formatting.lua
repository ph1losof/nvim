return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      formatters = {
        biome = {
          condition = function(_self, ctx)
            return vim.fs.find({ 'biome.json', 'biome.jsonc' }, { path = ctx.dirname, upward = true })[1] ~= nil
          end,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        less = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        python = { 'ruff_format', 'ruff' },
        json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        astro = { 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        ['markdown.mdx'] = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
        handlebars = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sql_formatter' },
        toml = { 'taplo' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        rust = { 'rustfmt' },
      },
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
        return {
          timeout_ms = 3000,
          lsp_format = lsp_format,
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
