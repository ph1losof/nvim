local last_operation = ''

-- Code Editor helper
local CodeEditor = {}
CodeEditor.__index = CodeEditor

function CodeEditor:new()
  local instance = setmetatable({}, CodeEditor)
  return instance
end

CodeEditor.deltas = {}

function CodeEditor:add_delta(bufnr, line, delta)
  table.insert(self.deltas, { bufnr = bufnr, line = line, delta = delta })
end

function CodeEditor:open_buffer(filename)
  if not filename or filename == '' then
    vim.notify('No filename provided to open_buffer', vim.log.levels.ERROR)
    return nil
  end

  if vim.fn.filereadable(filename) == 0 then
    vim.notify('File is unreadable. Path: ' .. filename, vim.log.levels.WARN)
  end

  local bufnr = vim.fn.bufadd(filename)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_current_buf(bufnr)

  return bufnr
end

function CodeEditor:get_bufnr_by_filename(filename)
  for _, bn in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bn) == filename then
      return bn
    end
  end
  return self:open_buffer(filename)
end

function CodeEditor:intersect(bufnr, line)
  local delta = 0
  for _, v in ipairs(self.deltas) do
    if bufnr == v.bufnr and line > v.line then
      delta = delta + v.delta
    end
  end
  return delta
end

function CodeEditor:delete(args)
  local start_line
  local end_line
  start_line = tonumber(args.start_line)
  assert(start_line, 'No start line number provided by the LLM')
  if start_line == 0 then
    start_line = 1
  end

  end_line = tonumber(args.end_line)
  assert(end_line, 'No end line number provided by the LLM')
  if end_line == 0 then
    end_line = 1
  end

  local bufnr = self:get_bufnr_by_filename(args.filename)

  if bufnr then
    local delta = self:intersect(bufnr, start_line)

    vim.api.nvim_buf_set_lines(bufnr, start_line + delta - 1, end_line + delta, false, {})
    self:add_delta(bufnr, start_line, (start_line - end_line - 1))
  else
    vim.notify("Can't find buffer number by file name.", vim.log.levels.ERROR)
  end
end

function CodeEditor:add(args)
  local start_line
  start_line = tonumber(args.start_line)
  assert(start_line, 'No line number provided by the LLM')
  if start_line == 0 then
    start_line = 1
  end

  local bufnr = self:get_bufnr_by_filename(args.filename)

  if bufnr then
    local delta = self:intersect(bufnr, start_line)

    local lines = vim.split(args.code, '\n', { plain = true, trimempty = false })
    vim.api.nvim_buf_set_lines(bufnr, start_line + delta - 1, start_line + delta - 1, false, lines)

    self:add_delta(bufnr, start_line, tonumber(#lines))
  else
    vim.notify("Can't find buffer number by file name", vim.log.levels.WARN)
  end
end

-- Code Extractor helper
local CodeExtractor = {}
CodeExtractor.__index = CodeExtractor

function CodeExtractor:new()
  local instance = setmetatable({}, CodeExtractor)
  return instance
end

CodeExtractor.lsp_timeout_ms = 10000
CodeExtractor.symbol_data = {}
CodeExtractor.filetype = ''

CodeExtractor.lsp_methods = {
  get_definition = vim.lsp.protocol.Methods.textDocument_definition,
  get_references = vim.lsp.protocol.Methods.textDocument_references,
  get_implementation = vim.lsp.protocol.Methods.textDocument_implementation,
}

CodeExtractor.DEFINITION_NODE_TYPES = {
  -- Functions and Classes
  function_definition = true,
  method_definition = true,
  class_definition = true,
  function_declaration = true,
  method_declaration = true,
  constructor_declaration = true,
  class_declaration = true,
  -- Variables and Constants
  variable_declaration = true,
  const_declaration = true,
  let_declaration = true,
  field_declaration = true,
  property_declaration = true,
  const_item = true,
  -- Language-specific definitions
  struct_item = true,
  function_item = true,
  impl_item = true,
  enum_item = true,
  type_item = true,
  attribute_item = true,
  trait_item = true,
  static_item = true,
  interface_declaration = true,
  type_declaration = true,
  decorated_definition = true,
}

function CodeExtractor:is_valid_buffer(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

function CodeExtractor:get_buffer_lines(bufnr, start_row, end_row)
  if not self:is_valid_buffer(bufnr) then
    vim.notify('Provided bufnr is invalid: ' .. bufnr, vim.log.levels.WARN)
    return nil
  end
  return vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)
end

function CodeExtractor:get_node_data(bufnr, node)
  if not (node and bufnr) then
    return nil
  end

  local start_row, start_col, end_row, end_col = node:range()
  local lines = self:get_buffer_lines(bufnr, start_row, end_row + 1)

  if not lines then
    vim.notify('Symbol text range is empty.', vim.log.levels.WARN)
    return nil
  end

  local code_block
  if start_row == end_row then
    code_block = lines[1]:sub(start_col + 1, end_col)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    code_block = table.concat(lines, '\n')
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)

  return {
    code_block = code_block,
    start_line = start_row + 1,
    end_line = end_row + 1,
    filename = filename,
  }
end

function CodeExtractor:get_symbol_data(bufnr, row, col)
  if not self:is_valid_buffer(bufnr) then
    vim.notify('Invalid buffer id:' .. bufnr)
    return nil
  end

  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    vim.notify("Can't initialize tree-sitter parser for buffer id: " .. bufnr, vim.log.levels.ERROR)
    return nil
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  while node do
    if self.DEFINITION_NODE_TYPES[node:type()] then
      return self:get_node_data(bufnr, node)
    end
    node = node:parent()
  end

  return nil
end

function CodeExtractor:validate_lsp_params(bufnr, method)
  if not (bufnr and method) then
    vim.notify('Unable to call lsp. Missing bufnr or method. buffer=' .. bufnr .. ' method=' .. method, vim.log.levels.WARN)
    return false
  end
  return true
end

function CodeExtractor:execute_lsp_request(bufnr, method)
  local position_params = vim.lsp.util.make_position_params(0, vim.lsp.client.offset_encoding)

  local results_by_client, err = vim.lsp.buf_request_sync(bufnr, method, position_params, self.lsp_timeout_ms)
  if err then
    vim.notify('LSP error: ' .. tostring(err), vim.log.levels.ERROR)
    return nil
  end
  return results_by_client
end

function CodeExtractor:process_single_range(uri, range)
  if not (uri and range) then
    return
  end

  local target_bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(target_bufnr)

  local data = self:get_symbol_data(target_bufnr, range.start.line, range.start.character)
  if data then
    table.insert(self.symbol_data, data)
  else
    vim.notify("Can't extract symbol data.", vim.log.levels.WARN)
  end
end

function CodeExtractor:process_lsp_result(result)
  if result.range then
    self:process_single_range(result.uri or result.targetUri, result.range)
    return
  end

  if #result > 10 then
    vim.notify('Too many results for symbol. Ignoring', vim.log.levels.WARN)
    return
  end

  for _, item in pairs(result) do
    self:process_single_range(item.uri or item.targetUri, item.range or item.targetSelectionRange)
  end
end

function CodeExtractor:call_lsp_method(bufnr, method)
  if not self:validate_lsp_params(bufnr, method) then
    return
  end

  local results_by_client = self:execute_lsp_request(bufnr, method)
  if not results_by_client then
    return
  end

  for _, lsp_results in pairs(results_by_client) do
    self:process_lsp_result(lsp_results.result or {})
  end
end

function CodeExtractor:move_cursor_to_symbol(symbol)
  local bufs = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_option_value('modifiable', { buf = bufnr }) then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

      for i, line in ipairs(lines) do
        local col = line:find(symbol)

        if col then
          local win_ids = vim.fn.win_findbuf(bufnr)
          if #win_ids > 0 then
            vim.api.nvim_set_current_win(win_ids[1])
            vim.api.nvim_win_set_cursor(0, { i, col - 1 })
            return bufnr
          end
          break
        end
      end
    end
  end
  return -1
end

local M = {}

function M:init()
  -- Initialize both helpers
  self.code_editor = CodeEditor:new()
  self.code_extractor = CodeExtractor:new()
end

function M:get_code_editor()
  return self.code_editor
end

function M:get_code_extractor()
  return self.code_extractor
end

return M
