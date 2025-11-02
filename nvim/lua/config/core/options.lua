--[[
  Core Neovim Options

  This file contains all core Vim settings and options that control editor behavior.
  These settings are applied before plugins load to ensure consistent behavior.

  For plugin-specific settings, see lua/config/plugins/
  For keybindings, see lua/config/core/keymaps.lua
  For autocommands, see lua/config/core/autocmds.lua
]]

-- Leader Keys
-- Must be set before plugins load to ensure correct leader key for all mappings
vim.g.mapleader = ' ' -- Space as leader key
vim.g.maplocalleader = ' ' -- Space as local leader key

-- UI & Display
vim.g.have_nerd_font = false -- Set to true if using a Nerd Font in terminal

vim.o.number = true -- Show line numbers
-- vim.o.relativenumber = true -- Show relative line numbers (uncomment if preferred)

vim.o.showmode = false -- Don't show mode in command line (already shown in statusline)
vim.o.signcolumn = 'yes' -- Always show sign column to prevent text shifting
vim.o.cursorline = true -- Highlight the current line
vim.o.scrolloff = 10 -- Minimum lines to keep above/below cursor
vim.o.wrap = false -- Disable line wrapping (can be toggled per buffer)

-- Display whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Splits & Windows
vim.o.splitright = true -- Vertical splits open to the right
vim.o.splitbelow = true -- Horizontal splits open below

-- Mouse & Input
vim.o.mouse = 'a' -- Enable mouse support in all modes

-- Clipboard
-- Sync clipboard between OS and Neovim (scheduled to avoid startup slowdown)
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Search
vim.o.ignorecase = true -- Case-insensitive search...
vim.o.smartcase = true -- ...unless search contains capital letters
vim.o.inccommand = 'split' -- Show live preview of substitution in split window

-- Indentation
vim.o.breakindent = true -- Preserve indentation in wrapped lines

-- File Handling
vim.o.undofile = true -- Persist undo history across sessions
vim.o.confirm = true -- Ask for confirmation instead of failing (e.g., :q with unsaved changes)

-- Performance & Timing
vim.o.updatetime = 250 -- Faster completion and file updates (default 4000)
vim.o.timeoutlen = 300 -- Time to wait for mapped sequence (default 1000)
