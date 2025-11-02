-- ===========================================================================
-- Mini.nvim - Collection of Independent Lua Modules
-- ===========================================================================
--
-- Mini.nvim is a collection of small, independent Lua modules that provide
-- various useful features. We use several of these modules for common
-- text editing operations and UI enhancements.
--
-- Modules included:
--   1. mini.ai - Extended textobjects (around/inside)
--   2. mini.surround - Add/delete/replace surroundings
--   3. mini.statusline - Simple and fast statusline
--
-- For more info:
--   :help mini.nvim
--   https://github.com/echasnovski/mini.nvim
--
-- ===========================================================================

return {
  'echasnovski/mini.nvim',

  config = function()
    -- ========================================================================
    -- Mini.ai - Enhanced Text Objects
    -- ========================================================================
    --
    -- Provides better "around" and "inside" textobjects with extended
    -- functionality for brackets, quotes, function calls, and more.
    --
    -- Examples:
    --   va)  - [V]isually select [A]round [)]parentheses
    --   yinq - [Y]ank [I]nside [N]ext [Q]uote
    --   ci'  - [C]hange [I]nside [']single quote
    --   vaN  - [V]isually select [A]round [N]ext textobject
    --   viL  - [V]isually select [I]nside [L]ast textobject
    --
    -- Supported textobjects:
    --   Brackets: (), [], {}, <>
    --   Quotes: ', ", `
    --   Special: t (tag), f (function call), a (argument)
    --
    -- For more info:
    --   :help mini.ai
    --
    require('mini.ai').setup {
      -- Number of lines within which textobject is searched
      n_lines = 500,
    }

    -- ========================================================================
    -- Mini.surround - Surround Operations
    -- ========================================================================
    --
    -- Add, delete, replace, find, and highlight surroundings (like brackets,
    -- quotes, tags, etc.)
    --
    -- Keybindings:
    --   sa<motion><char>  - [S]urround [A]dd: Add surrounding in Normal and Visual modes
    --                       Example: saiw) - Surround word with parentheses
    --                       Example: sa2j" - Surround next 2 lines with quotes
    --   sd<char>          - [S]urround [D]elete: Delete surrounding
    --                       Example: sd' - Delete surrounding quotes
    --   sr<old><new>      - [S]urround [R]eplace: Replace surrounding
    --                       Example: sr)' - Replace surrounding () with ''
    --   sf<char>          - [S]urround [F]ind: Find surrounding to the right
    --   sF<char>          - [S]urround [F]ind left: Find surrounding to the left
    --   sh<char>          - [S]urround [H]ighlight: Highlight surrounding
    --   sn                - [S]urround update [N]_lines: Update n_lines config
    --
    -- For more info:
    --   :help mini.surround
    --
    require('mini.surround').setup {
      mappings = {
        add = 'sa',            -- Add surrounding in Normal and Visual modes
        delete = 'sd',         -- Delete surrounding
        find = 'sf',           -- Find surrounding (to the right)
        find_left = 'sF',      -- Find surrounding (to the left)
        highlight = 'sh',      -- Highlight surrounding
        replace = 'sr',        -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines` config
      },
    }

    -- ========================================================================
    -- Mini.statusline - Simple Statusline
    -- ========================================================================
    --
    -- Provides a simple, fast, and customizable statusline that shows:
    --   - Current mode (Normal, Insert, Visual, etc.)
    --   - File name and modification status
    --   - Git branch and status (if available)
    --   - Diagnostics (errors, warnings)
    --   - File type and encoding
    --   - Cursor location (line:column)
    --
    -- For more info:
    --   :help mini.statusline
    --
    local statusline = require 'mini.statusline'

    statusline.setup {
      -- Set to true if you have a Nerd Font for pretty icons
      use_icons = vim.g.have_nerd_font,
    }

    -- Customize the location section to show LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
