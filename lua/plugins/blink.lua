return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'fang2hou/blink-copilot',
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
          Copilot = '',

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
          ecolog = { score_offset = 102, name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
          snippets = { score_offset = 101, max_items = 3, name = 'snippets', module = 'blink.cmp.sources.snippets' },
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          lsp = { score_offset = 99, name = 'lsp', module = 'blink.cmp.sources.lsp' },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 98,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
          dadbod = { name = 'dadbod', module = 'vim_dadbod_completion.blink' },
        },
        default = { 'ecolog', 'copilot', 'snippets', 'lazydev', 'lsp', 'path', 'buffer' },
        per_filetype = {
          codecompanion = { 'codecompanion' },
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
