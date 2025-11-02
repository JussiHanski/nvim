--[[
  Core Keybindings

  This file contains global keybindings that are not plugin-specific.
  Plugin-specific keybindings are defined within their respective plugin config files.

  Legend:
    <leader> = Space (defined in options.lua)
    <C-x>    = Ctrl+x
    <M-x>    = Alt+x (Meta key)
    <S-x>    = Shift+x
]]

-- Search & Highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {
  desc = 'Clear search highlights',
})

-- Diagnostics (LSP errors/warnings)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
  desc = 'Open diagnostic [Q]uickfix list',
})

-- Terminal Mode
-- Exit terminal mode with double escape (easier than default <C-\><C-n>)
-- Note: May not work in all terminal emulators
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {
  desc = 'Exit terminal mode',
})

-- Window Navigation
-- Use Ctrl+hjkl to navigate between windows (standard Vim window commands)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to window below' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to window above' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })

-- Window Movement (move windows themselves)
-- Note: Some terminals cannot send distinct keycodes for Ctrl+Shift combinations
-- Uncomment if your terminal supports these:
--
-- vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to far left' })
-- vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to bottom' })
-- vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to top' })
-- vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to far right' })

-- Disabled: Arrow Keys Training
-- Uncomment these to force yourself to use hjkl instead of arrow keys:
--
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move left!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move right!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move up!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move down!"<CR>')
