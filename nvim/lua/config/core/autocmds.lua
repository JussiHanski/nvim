--[[
  Core Autocommands

  This file contains automatic commands that respond to various Neovim events.
  Autocommands allow customizing behavior based on events like opening files,
  entering modes, or changing buffers.

  For more info: :help autocmd :help autocmd-events
]]

-- Delete conflicting Neovim 0.11+ default LSP keymaps
-- These default keymaps (grn, gra, etc.) conflict with our custom LSP bindings
-- Note: Only applies to Neovim 0.11+
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Remove conflicting default LSP keymaps',
  callback = function()
    pcall(vim.keymap.del, 'n', 'grn') -- Rename
    pcall(vim.keymap.del, 'n', 'gra') -- Code action
    pcall(vim.keymap.del, 'x', 'gra') -- Code action (visual)
    pcall(vim.keymap.del, 'n', 'grr') -- References
    pcall(vim.keymap.del, 'n', 'gri') -- Implementation
    pcall(vim.keymap.del, 'n', 'grd') -- Definition
    pcall(vim.keymap.del, 'n', 'grD') -- Declaration
    pcall(vim.keymap.del, 'n', 'grt') -- Type definition
  end,
})

-- Highlight on yank
-- Briefly highlight text when it's yanked (copied)
-- Try it: `yap` to yank a paragraph in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
