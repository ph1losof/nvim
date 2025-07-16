-- Set highlight on search, but clear on switching to normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-[', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- splits
vim.keymap.set('n', '<leader>sv', ':vsp<CR>', { desc = 'toggle vertical split', remap = true })
vim.keymap.set('n', '<leader>sh', ':sp<CR>', { desc = 'toggle horizontal split', remap = true })

-- insert mode mappings for moving around
vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'move beginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'move end of line' })
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'move left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'move right' })
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'move down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'move up' })

-- buffer opts
vim.keymap.set('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'General Copy whole file' })
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

-- clear highlights on escape
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', { desc = 'General Clear highlights' })

-- comments
vim.keymap.set({ 'n' }, '<leader>/', 'gcc', { desc = 'Toggle Comment', remap = true })
vim.keymap.set({ 'v' }, '<leader>/', 'gb', { desc = 'Toggle Comment', remap = true })

-- Primeagen's greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Press 'S' for quick find/replace for the word under the cursor
vim.keymap.set('n', 'S', function()
  local cmd = ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>'
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end)

-- Press 'U' for redo
vim.keymap.set('n', 'U', '<C-r>')

-- Press gx to open the link under the cursor
vim.keymap.set('n', 'gx', ':sil !open <cWORD><cr>', { silent = true })

-- Always use very magic mode for searching
vim.keymap.set('n', '/', [[/\v]])

-- prevent x delete from registering when next paste
vim.keymap.set('n', 'x', '"_x')

-- better increment/decrement numbers
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment numbers', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement numbers', noremap = true })

---@param mods string filename-modifiers
---@param buf_path string|nil file path (defaults to current buffer)
---@return string
---see: https://vim-jp.org/vimdoc-ja/cmdline.html#filename-modifiers
local function format_path(mods, buf_path)
  local path = buf_path or vim.fn.expand '%'
  return vim.fn.fnamemodify(path, mods)
end

---@param path string
local function copy_to_clipboard(path)
  vim.fn.setreg('+', path)
  vim.api.nvim_echo({ { 'Copied: ' .. path } }, false, {})
end

vim.keymap.set('n', '<leader>yfr', function()
  copy_to_clipboard(format_path ':.')
end, { desc = 'Copy relative file path to the clipboard' })

vim.keymap.set('n', '<leader>yfa', function()
  copy_to_clipboard(format_path ':.')
end, { desc = 'Copy absolute file path to the clipboard' })

vim.keymap.set('n', '<leader>yfn', function()
  copy_to_clipboard(format_path ':t')
end, { desc = 'Copy just the file name to the clipboard' })

-- vim: ts=2 sts=2 sw=2 et
