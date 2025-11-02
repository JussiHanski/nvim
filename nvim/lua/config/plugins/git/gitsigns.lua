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
      add = { text = '+' }, -- Line added
      change = { text = '~' }, -- Line changed
      delete = { text = '_' }, -- Line deleted
      topdelete = { text = '‾' }, -- Top of deleted block
      changedelete = { text = '~' }, -- Line changed and deleted
    },

    -- ========================================================================
    -- Keybindings for Hunk Operations
    -- ========================================================================

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Navigation between hunks
      vim.keymap.set('n', ']h', gs.next_hunk, { buffer = bufnr, desc = 'Next git [H]unk' })
      vim.keymap.set('n', '[h', gs.prev_hunk, { buffer = bufnr, desc = 'Previous git [H]unk' })

      -- Hunk actions
      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = '[H]unk [S]tage' })
      vim.keymap.set('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, desc = '[H]unk [S]tage (selection)' })
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = '[H]unk [R]eset' })
      vim.keymap.set('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, desc = '[H]unk [R]eset (selection)' })
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = '[H]unk [S]tage buffer' })
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = '[H]unk [U]ndo stage' })
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = '[H]unk [R]eset buffer' })
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = '[H]unk [P]review' })
      vim.keymap.set('n', '<leader>hb', function()
        gs.blame_line { full = true }
      end, { buffer = bufnr, desc = '[H]unk [B]lame line' })
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = '[H]unk [D]iff this' })
      vim.keymap.set('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { buffer = bufnr, desc = '[H]unk [D]iff this ~' })

      -- Toggle options
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = '[T]oggle git [B]lame' })
      vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = '[T]oggle [D]eleted lines' })

      -- Text object for hunks
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = 'Select hunk' })
    end,

    -- ========================================================================
    -- Additional Configuration
    -- ========================================================================

    -- Show current line blame by default (like VS Code GitLens)
    current_line_blame = false, -- Set to true to enable by default

    -- Blame line options
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000, -- Delay before showing (ms)
      ignore_whitespace = false,
    },

    -- Blame line format
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

    -- Show deleted lines
    show_deleted = false,

    -- Word diff highlighting
    word_diff = false,

    -- Watch git dir for changes
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },

    -- Attach to untracked files
    attach_to_untracked = true,

    -- Update debounce
    update_debounce = 100,

    -- Maximum file length to attach (performance)
    max_file_length = 40000,

    -- Sign priority
    sign_priority = 6,

    -- Status line integration
    status_formatter = nil, -- Use default
  },
}
