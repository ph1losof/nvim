return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      local helpers = require 'helpers'
      lint.linters_by_ft = {
        lua = { 'luacheck' },
        python = { 'pylint' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        yaml = { 'yamllint' },
        json = { 'jsonlint' },
        jsonc = { 'jsonlint' },
        gitcommit = { 'commitlint' },
        sql = { 'sqlfluff' },
        markdown = { 'markdownlint', 'vale' },
        ['markdown.mdx'] = { 'markdownlint' },
      }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filetype = vim.bo[bufnr].filetype
          local name = vim.api.nvim_buf_get_name(bufnr)

          if helpers.is_lspsaga_peek_window(bufnr) then
            return
          end

          if filetype:match('%.kulala_ui$') or name:match '^kulala://' then
            return
          end

          require('lint').try_lint()
        end,
      })
    end,
  },
}
