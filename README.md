# Neovim Configuration Tool

A cross-platform tool to manage and sync Neovim configurations across multiple machines.

## Why?

Working on multiple machines means keeping Neovim configurations in sync is a pain. This tool makes it trivial:
- Download one script
- Run one command
- Your Neovim config is ready to go

## Quick Start

### First Time Setup

```bash
# Download the bootstrap script
curl -fsSL https://raw.githubusercontent.com/JussiHanski/nvim/main/bootstrap.sh -o bootstrap.sh

# Initialize on your machine
bash bootstrap.sh init
```

This will:
- Clone this repository to `~/.config/nvim_config_tool/`
- Backup your existing Neovim config (if any)
- Create symlinks to use this config
- Install all plugins

### Update Configuration (Pull Latest Changes)

```bash
bash bootstrap.sh update
```

Or if you've already set up:

```bash
~/.config/nvim_config_tool/scripts/nvim-tool.sh update
```

### Clean/Reset

Remove symlinks and restore backup:

```bash
~/.config/nvim_config_tool/scripts/nvim-tool.sh clean
```

## How It Works

The tool creates a symlink from your standard Neovim config location (`~/.config/nvim/`) to the `nvim/` directory in this repository. Any changes you make in Neovim are immediately reflected in the git repository.

## Requirements

- Git
- Neovim (will be installed if missing, with your permission)
- curl or wget (for bootstrap download)
- Claude Code CLI (optional, for AI features)

## Claude Code Integration

The configuration includes claude-code.nvim, which embeds Claude Code directly into Neovim:

- Press `cc` or `Ctrl+,` to toggle Claude Code terminal
- Press `Ctrl+.` to continue previous conversation
- Automatic file reload when Claude Code modifies files
- Side-by-side editing with AI assistance

See `nvim/lua/custom/claude-setup.md` for detailed instructions.

## Platform Support

- ✅ Linux
- ✅ macOS
- ⏳ Windows (coming soon)

## Commands

| Command | Description |
|---------|-------------|
| `init` | First-time setup: clone, backup, symlink, install plugins |
| `update` | Pull latest config changes and update plugins |
| `clean` | Remove symlinks and optionally restore backup |
| `status` | Show current configuration status |

## Repository Structure

```
nvim_config_tool/
├── bootstrap.sh          # Bootstrap script for easy setup
├── nvim/                 # Your actual Neovim configuration
│   ├── init.lua         # Main config entry
│   └── lua/             # Lua modules
│       ├── core/        # Core settings
│       ├── plugins/     # Plugin configs
│       └── lsp/         # LSP configurations
└── scripts/
    └── nvim-tool.sh     # Management script
```

## License

MIT
