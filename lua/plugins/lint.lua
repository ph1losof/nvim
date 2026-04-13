return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      local helpers = require 'helpers'
      local vale_config = vim.fn.stdpath 'config' .. '/.vale.ini'

      if lint.linters.vale then
        local vale_args = lint.linters.vale.args or {}
        if not vim.tbl_contains(vale_args, '--config') then
          lint.linters.vale.args = vim.list_extend({
            '--config',
            function()
              return vim.fs.find('.vale.ini', { upward = true })[1] or vale_config
            end,
          }, vale_args)
        end
      end

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
