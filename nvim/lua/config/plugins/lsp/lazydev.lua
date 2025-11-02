-- ===========================================================================
-- Lazydev - Neovim Lua Development
-- ===========================================================================
--
-- Lazydev configures the Lua LSP (lua_ls) specifically for Neovim config
-- development. It provides proper completions, type checking, and
-- documentation for Neovim's Lua API.
--
-- Features:
--   - Neovim Lua API completions (vim.*, nvim_*)
--   - Plugin API completions
--   - Type checking for Neovim APIs
--   - Documentation on hover
--   - Integration with blink.cmp for enhanced completions
--
-- What it does:
--   - Adds Neovim runtime files to lua_ls workspace
--   - Configures lua_ls to understand Neovim-specific globals
--   - Loads type definitions for vim.uv (libuv bindings)
--   - Provides better completions than default lua_ls setup
--
-- For more info:
--   :help lazydev.nvim
--   https://github.com/folke/lazydev.nvim
--
-- ===========================================================================

return {
  'folke/lazydev.nvim',

  -- Only load for Lua files
  ft = 'lua',

  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      -- This provides completions for vim.uv.* functions (libuv bindings)
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },

      -- You can add more libraries here:
      -- { path = 'lazy.nvim', words = { 'LazyVim' } },
      -- { path = 'snacks.nvim', words = { 'Snacks' } },
    },
  },
}
