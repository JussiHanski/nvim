-- ===========================================================================
-- Guess Indent - Automatic Indentation Detection
-- ===========================================================================
--
-- Automatically detects and sets the indentation settings (tabstop and
-- shiftwidth) based on the current file's content. This is useful when
-- working on projects with different indentation styles.
--
-- Features:
--   - Automatically detects spaces vs tabs
--   - Detects indentation width (2, 4, 8 spaces)
--   - Works on buffer open
--   - Non-intrusive and lightweight
--
-- How it works:
--   When you open a file, guess-indent analyzes the indentation patterns
--   in the file and automatically sets vim.bo.tabstop, vim.bo.shiftwidth,
--   and vim.bo.expandtab to match the detected style.
--
-- For more info:
--   https://github.com/NMAC427/guess-indent.nvim
--
-- ===========================================================================

return {
  'NMAC427/guess-indent.nvim',

  -- No configuration needed - works automatically
  -- The plugin will run when you open a file and detect the indentation
}
