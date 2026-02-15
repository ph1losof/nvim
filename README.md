# My Neovim Config <3

```
Startuptime: 99.5ms

Based on the actual CPU time of the Neovim process till UIEnter.
This is more accurate than `nvim --startuptime`.
 LazyStart 6.34ms
 LazyDone  94.1ms (+87.75ms)
 UIEnter   99.5ms (+5.4ms)
```

## Introduction

This is my personal Neovim configuration that I use for day-to-day development.
Since I'm actively using it, it is in my very own interest to maintain and fix any issues that arise.

It contains a lot of "hacks" and little-known tricks I've accumulated over the years to make the experience better when working with certain plugins.

I've gone over numerous Neovim configs and combined the best autocommands, keymaps, and options that work for me.
Even though it is opinionated, it strikes a good balance between being ready to use now and providing good defaults as a starting point for your own configuration.

### Highlights

- **67+ plugins** organized across 38 separate plugin files
- **20 language servers** configured with smart root detection and conditional attachment
- **AI-augmented development** via Claude Code and Codeium integration
- **Custom tree-sitter parser** (`edf`) for `.env` file syntax highlighting
- **Format on save** with conform.nvim (prettier, stylua, ruff, rustfmt, and more)
- **10+ linters** running via nvim-lint
- **Modern completion** via blink.cmp with AI and LSP sources
- **Sensitive data masking** with shelter.nvim
- **Environment variable management** with ecolog2.nvim (including Doppler remote sources)
- **REST client** via kulala.nvim
- **Database interface** via vim-dadbod

### Languages Supported

TypeScript/JavaScript, React/Vue/Astro, Python, Rust, Lua, SQL, Bash, HTML/CSS/Tailwind, Markdown, TOML, YAML, JSON, Docker, GraphQL, Prisma, and Graphviz DOT.

## Installation

### Prerequisites

**Required:**

- **Neovim** >= 0.10
- **git**, **make**, **unzip**
- **C compiler** (`gcc` or `clang`) — needed by tree-sitter to compile parsers
- **[ripgrep](https://github.com/BurntSushi/ripgrep#installation)** — used by snacks.nvim picker for live grep
- **Node.js** & **npm** — required by many LSP servers and tools
- **[Nerd Font](https://www.nerdfonts.com/)** — provides icons used throughout the UI (`vim.g.have_nerd_font` is set to `true`)
- **Clipboard tool** — `pbcopy`/`pbpaste` (macOS), `xclip`/`xsel` (Linux), or `win32yank` (Windows)

**Recommended:**

- **[mise](https://mise.jdx.dev/)** — runtime version manager (config prepends mise shims to `PATH`)
- **[lazygit](https://github.com/jesseduffield/lazygit)** — terminal UI for git, integrated via snacks.nvim (`<leader>lg`)
- **[fd](https://github.com/sharkdp/fd)** — faster file finding for the picker

**Optional (language-specific):**

- **Deno** — for Deno project support (LSP activates when `deno.json`/`deno.jsonc` is present)
- **Python 3** — for Python development (pyright + ruff)
- **Rust/cargo** — for Rust development (rust-analyzer + rustfmt)

### Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/ph1losof/nvim ~/.config/nvim
   ```

2. Open Neovim — Lazy.nvim will auto-install all plugins on first launch:

   ```bash
   nvim
   ```

3. Install all LSP servers, formatters, and linters:

   ```vim
   :MasonInstallAll
   ```

4. Verify tree-sitter parsers are installed:

   ```vim
   :TSUpdate
   ```

## Project Structure

```
~/.config/nvim/
├── init.lua                  # Entry point (leader key, loads config modules)
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # Lazy.nvim bootstrap and setup
│   │   ├── options.lua       # Vim options and diagnostics
│   │   ├── mappings.lua      # Global keymaps
│   │   └── autocmds.lua      # Autocommands
│   ├── plugins/              # 38 plugin spec files (one per plugin/group)
│   └── helpers.lua           # Shared utility functions
├── snippets/                 # Custom snippets (drizzle, package.json, css)
├── patches/                  # Plugin patches (applied via patchr.nvim)
└── lazy-lock.json            # Plugin version lockfile
```

## Thanks

When I initially started using Neovim, my starting point was [NvChad](https://nvchad.com/). That's why you may find keybindings similar to NvChad's.

_This is a fork of [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) that moves from a single file to a multi-file configuration (huge thanks to them)._
