-- credits to https://github.com/k0ch4nx for the solution

---@module "lazy"
---@type LazySpec
return {
  ---@module "patchr"
  'nhu/patchr.nvim',
  opts = function(self, opts)
    local cmd = require 'patchr.cmd'
    local config = require 'patchr.config'

    local group = vim.api.nvim_create_augroup('patchr', { clear = false })
    local locked = false

    local function guard(fn)
      return function(...)
        if not locked then
          return fn(...)
        end
      end
    end

    local reset = function()
      cmd.reset(config.get_plugin_names())
    end

    local apply = function()
      cmd.apply(config.get_plugin_names(), true)
    end

    local function register(pattern)
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = pattern .. 'Pre',
        callback = guard(reset),
      })

      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = pattern,
        callback = guard(apply),
      })
    end

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'LazySyncPre',
      callback = function()
        locked = true
        reset()
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'LazySync',
      callback = function()
        apply()
        locked = false
      end,
    })

    vim.iter({ 'LazyInstall', 'LazyUpdate', 'LazyCheck' }):each(register)

    ---@type patchr.config
    return {
      autocmds = false,
      plugins = {
        ['typescript-tools.nvim'] = {
          vim.fn.expand '~/.config/nvim/patches/typescript-tools.patch',
        },
      },
    }
  end,
  lazy = false,
}
