-- Set leader key before anything else

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH

vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default to prevent jumps of buffer
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Better split settings to open new splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'cursor'

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Horizontal line to show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Enable incremental searching
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' }

-- Better completion experience
vim.opt.completeopt = 'menu,menuone,noselect'

-- ignore node_modules and .history
vim.opt.wildignore:append { '*/node_modules/*,*/.history/*' }

-- disable wrapping by default
vim.opt.wrap = false

-- session options (avoids blank buffers and stale options on restore)
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'folds', 'globals', 'help' }

-- indentation settings
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.showcmd = true

vim.opt.smarttab = true
vim.opt.expandtab = true

-- Make terminal use 24-bit colors
vim.o.termguicolors = true

-- Enable undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- show invisibles
vim.opt.listchars = { tab = '  ', trail = '·', extends = '»', precedes = '«', nbsp = '░' }
vim.opt.list = true

-- removes ~ at the end of buffer
vim.opt.fillchars = { eob = ' ' }

-- disable nvim intro
vim.opt.shortmess:append 'sI'

-- go to previous/next line with h,l
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append '<>[]hl'

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- enable colorcolumn
vim.opt.colorcolumn = '80'

-- register filetypes for logs and ecolog
vim.filetype.add {
  pattern = {
    ['%.env'] = 'edf',
    ['%.env%..*'] = 'edf',
    ['nohup.out'] = 'log',
  },
}

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
}

-- vim: ts=2 sts=2 sw=2 et
