-- Set leader key before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Local leader (defaults to global if not overridden)

require 'config.lazy'
require 'config.options'
require 'config.mappings'
require 'config.autocmds'
