--[[
  Plugin Manager Initialization

  This file sets up lazy.nvim plugin manager and configures how plugins are loaded.
  All plugin configurations are in categorized subdirectories:

  - ai/          : AI assistants (Claude Code, Copilot)
  - editor/      : Editor enhancements (Telescope, Treesitter, Which-key)
  - filesystem/  : File management (Oil, Neo-tree)
  - formatting/  : Code formatting (Conform)
  - git/         : Git integration (Gitsigns)
  - lsp/         : Language Server Protocol (Mason, LSP, Completion)
  - ui/          : UI and themes (Catppuccin)

  For more info: :help lazy.nvim
]]

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

-- Add lazy.nvim to runtime path
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Setup lazy.nvim with plugin imports
-- This will automatically load all plugin files from the subdirectories
require('lazy').setup({
  -- Import all plugins from categorized directories
  { import = 'config.plugins.ai' },
  { import = 'config.plugins.editor' },
  { import = 'config.plugins.filesystem' },
  { import = 'config.plugins.formatting' },
  { import = 'config.plugins.git' },
  { import = 'config.plugins.lsp' },
  { import = 'config.plugins.ui' },
}, {
  -- Lazy.nvim UI configuration
  ui = {
    -- Set icons based on Nerd Font availability
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
