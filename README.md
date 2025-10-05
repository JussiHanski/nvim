# Neovim Configuration Tool

A cross-platform tool to manage and sync Neovim configurations across multiple machines.

## Why?

Working on multiple machines means keeping Neovim configurations in sync is a pain. This tool makes it trivial:
- Download one script
- Run one command
- Your Neovim config is ready to go

## Quick Start

**📖 For detailed platform-specific instructions, see [INSTALL.md](INSTALL.md)**

### macOS/Linux

```bash
# Download and initialize in one command
bash <(curl -fsSL https://raw.githubusercontent.com/JussiHanski/nvim/main/bootstrap.sh) init
```

### Windows (PowerShell/cmd)

```cmd
git clone https://github.com/JussiHanski/nvim.git %USERPROFILE%\.config\nvim_config_tool
cd %USERPROFILE%\.config\nvim_config_tool
bootstrap.bat init
```

### What it does:

- Clones repository to `~/.config/nvim_config_tool/` (or `%USERPROFILE%\.config\nvim_config_tool` on Windows)
- Backs up existing Neovim config
- Creates symlinks/junctions to use this config
- Auto-installs dependencies and plugins
- Installs Neovim 0.11+ if missing

### Update Configuration

```bash
bash bootstrap.sh update      # Unix/Linux/macOS
bootstrap.bat update          # Windows
```

### Clean/Reset

```bash
bash bootstrap.sh clean       # Unix/Linux/macOS
bootstrap.bat clean          # Windows
```

## How It Works

The tool creates a symlink from your standard Neovim config location (`~/.config/nvim/`) to the `nvim/` directory in this repository. Any changes you make in Neovim are immediately reflected in the git repository.

## Requirements

**Critical (auto-installed if missing):**
- Git
- Neovim 0.11+
- Make
- C compiler (gcc/clang/MSVC)
- Ripgrep

**Optional (recommended):**
- fd (faster file search)
- cargo (Rust, for additional plugins)
- node/npm (for some LSP servers)
- Claude Code CLI (for AI assistant integration)

The bootstrap script handles dependency installation automatically on all platforms.

## Claude Code Integration

The configuration includes claude-code.nvim, which embeds Claude Code directly into Neovim:

- **`<leader>cc`** (Space+cc) or **`Ctrl+,`** - Toggle Claude Code terminal
- **`<leader>ca`** (Space+ca) - Add current file to Claude context with `@`
- **`<leader>cA`** (Space+cA) - Add all open files to Claude context
- **`Ctrl+.`** - Continue previous conversation
- Automatic file reload when Claude Code modifies files
- Side-by-side editing with AI assistance

See [CLAUDE.md](CLAUDE.md) for complete keybindings and features.

## Platform Support

- ✅ macOS (Intel & Apple Silicon)
- ✅ Linux (Ubuntu, Debian, Fedora, Arch)
- ✅ Windows (PowerShell/cmd with junction points)
- ✅ Windows WSL2 (Ubuntu/Debian)

See [INSTALL.md](INSTALL.md) for platform-specific installation instructions.

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
├── bootstrap.sh              # Bootstrap script (Unix/Linux/macOS)
├── bootstrap.bat             # Bootstrap script (Windows)
├── INSTALL.md                # Platform-specific installation guide
├── CLAUDE.md                 # Configuration reference and keybindings
├── nvim/                     # Actual Neovim configuration (kickstart.nvim based)
│   ├── init.lua             # Main config (1000+ lines, well-documented)
│   └── lua/
│       ├── kickstart/       # Optional kickstart plugins
│       └── custom/          # Your custom plugins
└── scripts/
    ├── nvim-tool.sh         # Management tool (Unix/Linux/macOS)
    └── nvim-tool.bat        # Management tool (Windows)
```

## License

MIT
