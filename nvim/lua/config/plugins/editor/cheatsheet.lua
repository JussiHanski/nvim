-- ===========================================================================
-- Cheatsheet - Quick Reference for Keybindings
-- ===========================================================================
--
-- Provides quick access to keybinding cheatsheets:
--   - KEYBINDINGS.md: Main cheatsheet with all Neovim and plugin keybindings
--   - LAZYGIT.md: Lazygit-specific commands and workflows
--
-- Keybindings:
--   <leader>?   : Open main keybindings cheatsheet
--   <leader>?l  : Open lazygit cheatsheet
--
-- The cheatsheets open in a vertical split on the right for easy reference
-- while working. Use :q to close them.
--
-- ===========================================================================

return {
  -- Not a real plugin, just keybindings configuration
  'nvim-telescope/telescope.nvim', -- Depends on telescope for file preview

  keys = {
    {
      '<leader>?',
      function()
        local cheatsheet_path = vim.fn.stdpath('config') .. '/../KEYBINDINGS.md'
        vim.cmd('vsplit ' .. cheatsheet_path)
      end,
      desc = 'Open keybindings cheatsheet',
    },
    {
      '<leader>?l',
      function()
        local lazygit_path = vim.fn.stdpath('config') .. '/../LAZYGIT.md'
        vim.cmd('vsplit ' .. lazygit_path)
      end,
      desc = 'Open [L]azygit cheatsheet',
    },
  },
}
