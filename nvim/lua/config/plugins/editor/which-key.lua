-- ===========================================================================
-- Which-Key - Keybinding Popup and Discovery
-- ===========================================================================
--
-- Which-Key displays a popup with possible keybindings when you start typing
-- a command. This is incredibly useful for discovering keybindings and
-- remembering complex key sequences.
--
-- Features:
--   - Displays available keybindings in a popup window
--   - Shows keybinding descriptions
--   - Configurable delay before popup appears
--   - Group keybindings by prefix
--   - Supports custom key labels and icons
--
-- Usage:
--   Simply start typing a key sequence (e.g., <leader>s) and wait for the
--   popup to appear. The popup will show all available keybindings that
--   start with that prefix.
--
-- Examples:
--   Type <leader> and wait - Shows all leader key mappings
--   Type g and wait - Shows all g-prefixed normal mode mappings
--   Type z and wait - Shows all z-prefixed normal mode mappings
--
-- For more info:
--   :help which-key.nvim
--   https://github.com/folke/which-key.nvim
--
-- ===========================================================================

return {
  'folke/which-key.nvim',
  event = 'VimEnter', -- Load when Neovim starts

  opts = {
    -- ========================================================================
    -- General Settings
    -- ========================================================================

    -- Delay (in milliseconds) before the which-key popup appears
    -- This is independent of vim.o.timeoutlen
    delay = 0,

    -- ========================================================================
    -- Icon Configuration
    -- ========================================================================

    icons = {
      -- Set to true if you have a Nerd Font installed and want icon mappings
      mappings = vim.g.have_nerd_font,

      -- Icon configuration for special keys
      -- If you have a Nerd Font, set this to an empty table to use default icons
      -- Otherwise, define ASCII representations of special keys
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },

    -- ========================================================================
    -- Keybinding Groups
    -- ========================================================================

    -- Document existing key chains
    -- This helps organize keybindings into logical groups
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>c', group = '[C]laude/Copilot' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>g', group = '[G]it' },
    },
  },
}
