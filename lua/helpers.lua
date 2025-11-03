local M = {}

--- NOTE: This prevents issues like marksman LSP exiting when peek windows are created.

--- Check if buffer is an LSPSaga peek definition window.
--- LSPSaga creates special markdown preview buffers for peeking definitions.
--- These buffers should not trigger LSP/linting as they are temporary non-editable previews.
--- See: https://github.com/nvimdev/lspsaga.nvim/issues/1352
---@param bufnr number The buffer number to check.
---@return boolean true if buffer is an LSPSaga peek window, false otherwise.
function M.is_lspsaga_peek_window(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype
  local modifiable = vim.bo[bufnr].modifiable

  if (filetype == 'markdown' or filetype == 'markdown.mdx') and buftype == 'nofile' and not modifiable then
    return true
  end

  return false
end

return M
