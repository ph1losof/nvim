return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      {
        'Exafunction/codeium.nvim',
        cmd = 'Codeium',
        event = 'InsertEnter',
        build = ':Codeium Auth',
        opts = {
          enable_cmp_source = false,
          virtual_text = {
            enabled = false,
          },
        },
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
          Codeium = '',

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
          codeium = {
            name = 'Codeium',
            module = 'codeium.blink',
            enabled = function()
              local path = vim.api.nvim_buf_get_name(0)
              if string.find(path, 'oil://', 1, true) == 1 then
                return false
              end
              return true
            end,
            score_offset = 98,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Codeium'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
            async = true,
          },
          dadbod = { name = 'dadbod', module = 'vim_dadbod_completion.blink' },
        },
        default = { 'ecolog', 'codeium', 'snippets', 'lazydev', 'lsp', 'path', 'buffer' },
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
