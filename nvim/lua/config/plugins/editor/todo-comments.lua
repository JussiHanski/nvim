-- ===========================================================================
-- Todo Comments - Highlight and Search TODO Comments
-- ===========================================================================
--
-- Highlights and provides search functionality for TODO, HACK, BUG, NOTE,
-- and other special comments in your code.
--
-- Features:
--   - Syntax highlighting for special comment keywords
--   - Search and list all todos in your project
--   - Jump between todos
--   - Customizable keywords and colors
--   - Integration with Telescope
--
-- Recognized Keywords (by default):
--   TODO:   - Something to be done
--   HACK:   - Hacky solution that should be improved
--   BUG:    - Known bug that needs fixing
--   FIXME:  - Should be corrected
--   NOTE:   - Important note or explanation
--   WARN:   - Warning about something
--   PERF:   - Performance-related comment
--   TEST:   - Testing-related comment
--
-- Commands:
--   :TodoTelescope      - Search todos with Telescope
--   :TodoQuickFix       - Open todos in quickfix list
--   :TodoLocList        - Open todos in location list
--   :TodoTrouble        - Open todos in Trouble (if installed)
--
-- For more info:
--   :help todo-comments.nvim
--   https://github.com/folke/todo-comments.nvim
--
-- ===========================================================================

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter', -- Load when Neovim starts
  dependencies = { 'nvim-lua/plenary.nvim' },

  opts = {
    -- Don't show icons in the sign column (set to true if you want them)
    signs = false,

    -- Keywords configuration
    -- You can customize this to add your own keywords or change colors
    -- keywords = {
    --   TODO = { icon = " ", color = "info" },
    --   HACK = { icon = " ", color = "warning" },
    --   WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
    --   PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE" } },
    --   NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    -- },
  },
}
