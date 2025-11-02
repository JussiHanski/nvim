-- ===========================================================================
-- Catppuccin - Soothing Pastel Theme
-- ===========================================================================
--
-- Catppuccin is a warm, pastel-themed colorscheme designed for comfort and
-- readability during long coding sessions. It comes in four flavors, each
-- with different background darkness levels.
--
-- Flavors:
--   - latte:     Light theme (like a latte)
--   - frappe:    Medium-dark theme (like a frappé)
--   - macchiato: Dark theme (like a macchiato)
--   - mocha:     Darkest theme (like a mocha) [DEFAULT]
--
-- Features:
--   - Support for many plugins (Treesitter, LSP, Telescope, etc.)
--   - Consistent colors across different plugins
--   - Italic and bold variations
--   - Customizable palette
--   - Terminal color integration
--
-- Commands:
--   :colorscheme catppuccin-latte
--   :colorscheme catppuccin-frappe
--   :colorscheme catppuccin-macchiato
--   :colorscheme catppuccin-mocha
--
-- To switch between flavors at runtime:
--   :Catppuccin latte
--   :Catppuccin frappe
--   :Catppuccin macchiato
--   :Catppuccin mocha
--
-- For more info:
--   :help catppuccin
--   https://github.com/catppuccin/nvim
--
-- Alternative Colorschemes:
--   - tokyonight.nvim: Clean, dark Tokyo-themed colors
--   - gruvbox.nvim: Retro groove warm theme
--   - nord.nvim: Arctic, north-bluish theme
--   - onedark.nvim: Atom's iconic One Dark theme
--   - kanagawa.nvim: Dark theme inspired by famous painting
--
-- ===========================================================================

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load before all other plugins to ensure theme is applied first

  config = function()
    -- ========================================================================
    -- Catppuccin Configuration
    -- ========================================================================

    require('catppuccin').setup {
      -- Theme flavor: latte, frappe, macchiato, mocha
      flavour = 'mocha',

      -- Disable italic text (set to false if you want italics)
      no_italic = true,

      -- Additional configuration options:
      --
      -- Disable bold text
      -- no_bold = false,
      --
      -- Disable underline
      -- no_underline = false,
      --
      -- Transparent background
      -- transparent_background = false,
      --
      -- Integration with specific plugins
      -- integrations = {
      --   telescope = true,
      --   treesitter = true,
      --   which_key = true,
      --   gitsigns = true,
      --   mason = true,
      --   cmp = true,
      --   native_lsp = {
      --     enabled = true,
      --   },
      -- },
      --
      -- Custom color overrides
      -- color_overrides = {},
      --
      -- Custom highlight overrides
      -- custom_highlights = {},
    }

    -- ========================================================================
    -- Apply Colorscheme
    -- ========================================================================

    -- Apply the selected flavor
    -- Available: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
