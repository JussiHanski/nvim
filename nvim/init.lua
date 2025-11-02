--[[
════════════════════════════════════════════════════════════════════════════
  Neovim Configuration

  A modern, modular Neovim configuration focused on clarity and maintainability.
  All configuration is organized by category in lua/config/

  Structure:
    config/core/      - Core Vim settings (options, keymaps, autocommands)
    config/plugins/   - Plugin configurations organized by category
    config/utils/     - Utility functions and helpers

  Quick Start:
    <Space>sh  - Search help documentation
    <Space>sf  - Search files (fuzzy finder)
    <Space>e   - Toggle file explorer
    :Lazy      - Manage plugins
    :checkhealth - Check configuration health

  For detailed documentation, see CLAUDE.md in the repository root.
════════════════════════════════════════════════════════════════════════════
]]

-- Load core configuration
require 'config.core.options' -- Vim options and settings
require 'config.core.keymaps' -- Global keybindings
require 'config.core.autocmds' -- Autocommands

-- Load plugin manager and all plugins
require 'config.plugins'

-- Configuration complete!
-- Plugin-specific keybindings and settings are defined within each plugin file
-- located in lua/config/plugins/
