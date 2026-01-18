# AGENTS.md

This repository contains a modular Neovim configuration written in Lua. Most code lives under `nvim/` and is loaded by lazy.nvim. Use this file to align changes with existing conventions.

## Repository layout

- `nvim/init.lua`: entry point, loads core config and plugins.
- `nvim/lua/config/core/`: options, keymaps, autocmds.
- `nvim/lua/config/plugins/`: plugin specs grouped by category.
- `scripts/nvim-tool.sh` + `scripts/nvim-tool.bat`: bootstrap, update, clean, status.
- `nvim/.stylua.toml`: formatting rules for Lua.

## Build / Lint / Test commands

There is no traditional build, lint, or test suite in this repo. Use the tooling below instead.

### Bootstrap / update commands

- Initialize config (Unix): `bash bootstrap.sh init`
- Initialize config (Windows): `bootstrap.bat init`
- Update config + plugins (Unix): `bash bootstrap.sh update`
- Update config + plugins (Windows): `bootstrap.bat update`
- Status (Unix): `./scripts/nvim-tool.sh status`
- Status (Windows): `scripts\nvim-tool.bat status`

### Plugin sync / health

- Install/update plugins headless: `nvim --headless "+Lazy! sync" +qa`
- Check Neovim health: `nvim --headless "+checkhealth" +qa`

### Formatting (Lua)

- Format Lua files using Stylua and repo config:
  `stylua --config-path nvim/.stylua.toml nvim`

### Single test

- No automated test runner found. If you add tests later, document single-test commands here.

## Code style guidelines

### Lua formatting

- Formatter: Stylua via `nvim/.stylua.toml`.
- Indent: 2 spaces.
- Line width: 160 columns.
- Quote style: prefer single quotes.
- Call parentheses: omit when possible (`call_parentheses = None`).

### Imports and module structure

- Use `require` with single quotes, e.g. `require 'config.core.options'`.
- Keep modules focused; place new configs under `nvim/lua/config/`.
- Plugin specs live in `nvim/lua/config/plugins/<category>/` and should return a lazy.nvim spec table.
- Register new plugin categories by adding `{ import = 'config.plugins.<category>' }` in `nvim/lua/config/plugins/init.lua`.

### Naming conventions

- Local variables use lower_snake_case or lowerCamelCase as already established (prefer existing file style).
- Functions are usually `lower_snake_case` for helper functions.
- Plugin names and file names are lowercase with dashes/underscores matching existing patterns.

### Options, keymaps, and autocmds

- Options: prefer `vim.o` or `vim.opt` in `nvim/lua/config/core/options.lua`.
- Keymaps: use `vim.keymap.set` with a `desc` field for discoverability.
- Autocmds: use `vim.api.nvim_create_autocmd` with a `desc` field.
- Keep global keymaps in `nvim/lua/config/core/keymaps.lua`. Plugin-specific mappings go in the plugin file.

### Plugin configuration

- Use lazy.nvim specs with fields like `event`, `cmd`, `keys`, `opts`, `config`.
- Organize plugins by category (ai, editor, filesystem, formatting, git, lsp, ui).
- For LSP:
  - Add server configs to the `servers` table in `nvim/lua/config/plugins/lsp/lspconfig.lua`.
  - Mason installs tools listed in `ensure_installed` (currently includes `stylua`).

### Error handling and safety

- Use `pcall` for optional operations that may not exist (example: deleting default keymaps).
- Prefer early checks with readable errors (see `scripts/nvim-tool.sh`).
- Use `error(...)` for unrecoverable setup failures in Lua modules.

### Comments and structure

- Keep top-of-file headers if the file already uses them.
- Avoid excessive inline comments; add comments only when behavior is non-obvious.
- Maintain existing section dividers and spacing patterns in Lua configs.

## Cursor / Copilot rules

- No `.cursorrules`, `.cursor/rules/`, or `.github/copilot-instructions.md` found.

## Agent tips

- Most user-facing behavior is driven by Neovim plugins; verify changes by launching Neovim or running headless commands.
- When updating formatters or LSP servers, keep `conform.lua` and `lspconfig.lua` in sync.
- Avoid adding new tooling unless it is required by the configuration.
