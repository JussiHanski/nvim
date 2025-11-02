-- ===========================================================================
-- Gitsigns - Git Integration and Change Indicators
-- ===========================================================================
--
-- Gitsigns adds git-related signs to the gutter (sign column) and provides
-- utilities for managing git changes directly from Neovim.
--
-- Features:
--   - Git diff signs in the gutter (add, change, delete)
--   - Stage/unstage hunks
--   - Preview changes
--   - Navigate between hunks
--   - Blame information
--   - Integration with other plugins
--
-- Signs in the gutter:
--   + - Line added
--   ~ - Line changed
--   _ - Line deleted
--   ‾ - Top of deleted block
--
-- Common Commands:
--   :Gitsigns stage_hunk        - Stage the current hunk
--   :Gitsigns undo_stage_hunk   - Unstage the current hunk
--   :Gitsigns reset_hunk        - Reset the current hunk
--   :Gitsigns preview_hunk      - Preview changes in floating window
--   :Gitsigns blame_line        - Show git blame for current line
--   :Gitsigns toggle_current_line_blame - Toggle inline blame
--
-- For more info:
--   :help gitsigns
--   https://github.com/lewis6991/gitsigns.nvim
--
-- Note: For more advanced git operations, consider using plugins like:
--   - fugitive.vim
--   - neogit
--   - lazygit.nvim
--
-- ===========================================================================

return {
  'lewis6991/gitsigns.nvim',

  opts = {
    -- ========================================================================
    -- Sign Configuration
    -- ========================================================================

    signs = {
      -- Characters displayed in the sign column
      add          = { text = '+' },  -- Line added
      change       = { text = '~' },  -- Line changed
      delete       = { text = '_' },  -- Line deleted
      topdelete    = { text = '‾' },  -- Top of deleted block
      changedelete = { text = '~' },  -- Line changed and deleted
    },

    -- ========================================================================
    -- Additional Configuration
    -- ========================================================================

    -- You can add more configuration here. Some useful options:
    --
    -- Show line blame inline (like VS Code)
    -- current_line_blame = true,
    --
    -- Delay before showing blame (ms)
    -- current_line_blame_opts = {
    --   delay = 1000,
    -- },
    --
    -- Keymaps for hunk operations
    -- on_attach = function(bufnr)
    --   local gs = package.loaded.gitsigns
    --
    --   -- Navigation between hunks
    --   vim.keymap.set('n', ']c', gs.next_hunk, { buffer = bufnr, desc = 'Next git hunk' })
    --   vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = bufnr, desc = 'Previous git hunk' })
    --
    --   -- Actions
    --   vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = '[H]unk [S]tage' })
    --   vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = '[H]unk [R]eset' })
    --   vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = '[H]unk [P]review' })
    --   vim.keymap.set('n', '<leader>hb', gs.blame_line, { buffer = bufnr, desc = '[H]unk [B]lame' })
    -- end,
  },
}
