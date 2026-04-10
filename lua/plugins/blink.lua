return {
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      {
        'saghen/blink.compat',
        version = '2.*',
        opts = {},
      },
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        version = 'v2.*',
        dependencies = 'rafamadriz/friendly-snippets',
        opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
        config = function(_, opts)
          require('luasnip').config.set_config(opts)
          require('luasnip.loaders.from_vscode').lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
          require('luasnip.loaders.from_vscode').lazy_load { paths = vim.g.vscode_snippets_path or '' }
          require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }

          require('luasnip.loaders.from_snipmate').load()
          require('luasnip.loaders.from_snipmate').lazy_load { paths = vim.g.snipmate_snippets_path or '' }

          require('luasnip.loaders.from_lua').load()
          require('luasnip.loaders.from_lua').lazy_load { paths = vim.g.lua_snippets_path or '' }
        end,
      },
    },
    version = '1.*', -- use a release tag to download pre-built binaries
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {
          Supermaven = '',
          ['99'] = '󱐋',

          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',

          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',

          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',

          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',

          Keyword = '󰻾',
          Constant = '󰏿',

          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
        },
      },
      signature = {
        enabled = true,
      },
      snippets = {
        preset = 'luasnip',
      },
      sources = {
        providers = {
          snippets = { score_offset = 102, max_items = 3, name = 'snippets', module = 'blink.cmp.sources.snippets' },
          supermaven = {
            score_offset = 101,
            override = {
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
                return trigger_characters
              end,
            },
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Supermaven'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
            name = 'supermaven',
            module = 'blink.compat.source',
            async = true,
          },

          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          lsp = { score_offset = 99, name = 'lsp', module = 'blink.cmp.sources.lsp' },
          ['99'] = {
            name = '99',
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = '99'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
            module = 'blink.compat.source',
            score_offset = 98,
          },
          dadbod = { name = 'dadbod', module = 'vim_dadbod_completion.blink' },
        },
        default = { 'supermaven', '99', 'snippets', 'lazydev', 'lsp', 'path', 'buffer' },
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
        },
      },
      completion = {
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          treesitter_highlighting = true,
          auto_show_delay_ms = 0,
        },
        trigger = {
          show_on_blocked_trigger_characters = {},
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
