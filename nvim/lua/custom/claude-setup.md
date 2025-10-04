# Claude Code Setup for Neovim

This configuration includes claude-code.nvim for integrating Claude Code directly into Neovim.

## What is Claude Code?

Claude Code is Anthropic's CLI tool for AI-powered coding assistance. This plugin embeds the Claude Code terminal interface directly into Neovim.

## Requirements

- Claude Code CLI must be installed and working
- The `claude` command should be available in your PATH
- Neovim 0.7.0+

## Usage

**Toggle Claude Code Terminal:**
- Press `cc` in normal mode to toggle Claude Code terminal
- Or press `Ctrl+,` (default binding)
- Terminal opens on the right side of your editor

**Continue Previous Conversation:**
- Press `Ctrl+.` to continue the last Claude Code session
- Or use `:ClaudeCodeContinue` command

**Commands:**
- `:ClaudeCode` - Toggle Claude Code terminal
- `:ClaudeCodeContinue` - Continue previous conversation

## Features

**Automatic File Reloading:**
- Plugin detects when Claude Code modifies files
- Automatically reloads changed files in Neovim
- Checks every 1000ms by default

**Git Integration:**
- Automatically uses git project root as working directory
- Ensures Claude Code has full project context

**Customizable Window:**
- Position: right, left, top, bottom, or floating
- Adjustable size
- Floating window with rounded borders

## Configuration

The default setup in init.lua can be customized:

```lua
require('claude-code').setup({
  terminal = {
    position = 'right',  -- Change to 'left', 'top', 'bottom', 'float'
    size = 80,           -- Width/height depending on position
  },
  refresh = {
    enabled = true,
    interval = 1000,     -- Milliseconds between file checks
  },
})
```

## Troubleshooting

If Claude Code is not working:

1. Verify Claude Code CLI is installed:
   ```bash
   which claude
   ```

2. Check plugin installation in Neovim:
   ```vim
   :Lazy
   ```

3. View logs:
   ```vim
   :messages
   ```

## Benefits

- Work with Claude Code without leaving Neovim
- Automatic file synchronization
- Full Vim keybindings available in terminal mode
- Side-by-side editing and AI assistance
