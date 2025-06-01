local code_module = require 'custom.codecompanion.codeeditor'

return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
        -- copilot_model = 'gpt-4o-copilot',
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    keys = {
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      { '<Leader>aa', '<cmd>CodeCompanionActions<CR>', desc = 'toggle a chat buffer', mode = { 'n', 'v' } },
      { '<leader>ae', ":<C-u>'<,'>CodeCompanion ", mode = 'v', desc = 'Inline prompt (CodeCompanion)', silent = false, noremap = true },
      { '<leader>ae', '<cmd>CodeCompanion<cr>', mode = 'n', desc = 'Inline prompt (CodeCompanion)' },
      { '<Leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'toggle a chat buffer', mode = { 'n', 'v' } },
      { '<LocalLeader>ac', '<cmd>CodeCompanionChat Add<CR>', desc = 'Add code to a chat buffer', mode = { 'v' } },
    },
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },
    init = function()
      require('custom.codecompanion.spinner'):init()
      require('custom.codecompanion.codeeditor'):init()
    end,
    opts = {
      display = {
        diff = {
          provider = 'mini_diff',
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'gemini-2.5-pro',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'gemini',
          start_in_insert_mode = false,
          tools = {
            opts = {
              auto_submit_errors = true,
              auto_submit_success = false,
            },
            code_developer = {
              description = 'Act as developer by utilizing LSP methods and code modification capabilities.',
              opts = {
                user_approval = false,
              },
              callback = {
                name = 'code_developer',
                cmds = {
                  function(_, args, _)
                    local operation = args.operation
                    last_operation = operation
                    local symbol = args.symbol

                    if operation == 'edit' then
                      local code_editor = code_module:get_code_editor()
                      code_editor:delete(args)
                      code_editor:add(args)
                      return { status = 'success', data = 'Code has beed updated' }
                    else
                      local code_extractor = code_module:get_code_extractor()
                      local bufnr = code_extractor:move_cursor_to_symbol(symbol)

                      if code_extractor.lsp_methods[operation] then
                        code_extractor:call_lsp_method(bufnr, code_extractor.lsp_methods[operation])
                        code_extractor.filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                        return { status = 'success', data = 'Tool executed successfully' }
                      else
                        vim.notify('Unsupported LSP method', vim.log.levels.WARN)
                      end
                    end

                    return { status = 'error', data = 'No symbol found' }
                  end,
                },
                schema = {
                  type = 'function',
                  ['function'] = {
                    name = 'code_developer',
                    description = 'Act as developer by utilizing LSP methods and code modification capabilities.',
                    parameters = {
                      type = 'object',
                      properties = {
                        operation = {
                          type = 'string',
                          enum = {
                            'get_definition',
                            'get_references',
                            'get_implementation',
                            'edit',
                          },
                          description = 'The action to be performed by the code developer tool',
                        },
                        symbol = {
                          type = 'string',
                          description = 'The symbol to be processed by the code developer tool',
                        },
                        filename = {
                          type = 'string',
                          description = 'The name of the file to be modified',
                        },
                        start_line = {
                          type = 'integer',
                          description = 'The starting line number of the code block to be modified',
                        },
                        end_line = {
                          type = 'integer',
                          description = 'The ending line number of the code block to be modified',
                        },
                        code = {
                          type = 'string',
                          description = 'The new code to be inserted into the file',
                        },
                      },
                      required = {
                        'operation',
                      },
                      additionalProperties = false,
                    },
                    strict = true,
                  },
                },
                system_prompt = [[## Code Developer Tool (`code_developer`) Guidelines

## MANDATORY USAGE
Use `get_definition`, `get_references` or `get_implementation` AT THE START of EVERY coding task to gather context before answering. Don't overuse these actions. Think what is needed to solve the task, don't fall into rabbit hole.
Use `edit` action only when asked by user.

## Purpose
Traverses the codebase to find definitions, references, or implementations of code symbols to provide error proof solution
OR
Replace old code with new implementation

## Important
- Wait for tool results before providing solutions
- Minimize explanations about the tool itself
- When looking for symbol, pass only the name of symbol without the object. E.g. use: `saveUsers` instead of `userRepository.saveUsers`
]],
                handlers = {
                  on_exit = function(self, agent)
                    local code_extractor = code_module:get_code_extractor()
                    code_extractor.symbol_data = {}
                    code_extractor.filetype = ''
                    vim.notify 'Tool executed successfully'
                    return agent.chat:submit()
                  end,
                },
                output = {
                  success = function(self, agent, cmd, stdout)
                    local operation = self.args.operation
                    if operation == 'edit' then
                      return agent.chat:add_tool_output(self, 'Code modified', 'Code modified')
                    end

                    local code_extractor = code_module:get_code_extractor()
                    local symbol = self.args.symbol
                    local buf_message_content = ''

                    for _, code_block in ipairs(code_extractor.symbol_data) do
                      buf_message_content = buf_message_content
                        .. string.format(
                          [[
---
The %s of symbol: `%s`
Filename: %s
Start line: %s
End line: %s
Content:
```%s
%s
```
]],
                          string.upper(operation),
                          symbol,
                          code_block.filename,
                          code_block.start_line,
                          code_block.end_line,
                          code_extractor.filetype,
                          code_block.code_block
                        )
                    end

                    return agent.chat:add_tool_output(self, buf_message_content, buf_message_content)
                  end,
                  error = function(self, agent, cmd, stderr, stdout)
                    return agent.chat:add_tool_output(self, tostring(stderr[1]), tostring(stderr[1]))
                  end,
                },
              },
            },
          },
          roles = {
            user = 'tentacles',
          },
          slash_commands = {
            ['git_files'] = {
              description = 'List git files',
              ---@param chat CodeCompanion.Chat
              callback = function(chat)
                local handle = io.popen 'git ls-files'
                if handle ~= nil then
                  local result = handle:read '*a'
                  handle:close()
                  chat:add_reference({ role = 'user', content = result }, 'git', '<git_files>')
                else
                  return vim.notify('No git files available', vim.log.levels.INFO, { title = 'CodeCompanion' })
                end
              end,
              opts = {
                contains_code = false,
              },
            },
            ['file'] = {
              callback = 'strategies.chat.slash_commands.file',
              description = 'Select a file using Snacks picker',
              opts = {
                provider = 'snacks',
                contains_code = true,
              },
            },
            ['help'] = {
              opts = {
                max_lines = 1000,
              },
            },
          },
        },
        inline = {
          adapter = 'gemini',
          keymaps = {
            accept_change = {
              modes = { n = 'ga' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = 'gr' },
              description = 'Reject the suggested change',
            },
          },
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = 'gh',
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            picker = 'snacks',
            enable_logging = false,
            dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
          },
        },
        -- WARN: after migration to fish doesn't work
        --[[ vectorcode = {
          opts = {
            add_tool = true,
          },
        }, ]]
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim',
      'j-hui/fidget.nvim',
      'ravitemer/codecompanion-history.nvim', -- Save and load conversation history
      'echasnovski/mini.diff',
      {
        'ravitemer/mcphub.nvim', -- Manage MCP servers
        cmd = 'MCPHub',
        build = 'npm install -g mcp-hub@latest',
        config = true,
      },
      -- WARN: after migration to fish doesn't work
      --[[ {
        'Davidyz/VectorCode',
        version = '*',
        build = 'pipx upgrade vectorcode',
        dependencies = { 'nvim-lua/plenary.nvim' },
      }, ]]
      {
        'HakonHarnes/img-clip.nvim',
        ft = { 'codecompanion' },
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = '[Image]($FILE_PATH)',
              use_absolute_path = true,
            },
          },
        },
      },
    },
  },
}
