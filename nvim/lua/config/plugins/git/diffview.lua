-- ===========================================================================
-- Diffview - Visual Diff and Merge Conflict Resolution
-- ===========================================================================
--
-- Diffview provides a single tabpage interface for reviewing diffs, viewing
-- file history, and resolving merge conflicts with ease.
--
-- Features:
--   - Visual diff review for all changed files
--   - File history with commit navigation
--   - Merge conflict resolution with 3-way diff
--   - Stage/unstage hunks visually
--   - Compare any two git revisions
--   - Multiple layout options
--
-- Main Commands:
--   :DiffviewOpen [rev]              - Open diff view (default: current changes)
--   :DiffviewOpen HEAD~2             - Diff between HEAD~2 and working tree
--   :DiffviewOpen HEAD~2..HEAD~1     - Diff between two commits
--   :DiffviewClose                   - Close diff view
--   :DiffviewToggleFiles             - Toggle file panel
--   :DiffviewFocusFiles              - Focus file panel
--   :DiffviewRefresh                 - Refresh diff view
--
--   :DiffviewFileHistory [paths]     - Open file history
--   :DiffviewFileHistory %           - History of current file
--   :DiffviewFileHistory --range=origin/main...HEAD  - Commits in range
--
-- Keybindings (in diff view):
--   Tab/<S-Tab>  : Cycle through changed files
--   gf           : Open file in new tab
--   <C-w>gf      : Open file in new split
--   [x / ]x      : Previous/next conflict (in merge conflicts)
--   <leader>co   : Choose ours (merge conflict)
--   <leader>ct   : Choose theirs (merge conflict)
--   <leader>cb   : Choose both (merge conflict)
--   <leader>cB   : Choose base (merge conflict)
--
-- Keybindings (in file panel):
--   j/k          : Navigate files
--   <CR>         : Open diff for file
--   s            : Stage file
--   u            : Unstage file
--   -            : Stage/unstage file (toggle)
--   R            : Refresh files
--   L            : Open commit log
--   gf           : Open file
--
-- Workflow Examples:
--   # Review current uncommitted changes
--   :DiffviewOpen
--
--   # Review changes in last commit
--   :DiffviewOpen HEAD~1
--
--   # Compare two branches
--   :DiffviewOpen main..feature-branch
--
--   # View file history
--   :DiffviewFileHistory %
--
--   # Resolve merge conflicts
--   (Conflicts appear automatically in 3-way diff)
--   Use ]x/[x to jump between conflicts
--   Use <leader>co/ct/cb to choose sides
--
-- For more info:
--   :help diffview
--   https://github.com/sindrets/diffview.nvim
--
-- ===========================================================================

return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Optional: for file icons
  },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  keys = {
    { '<leader>dv', '<cmd>DiffviewOpen<cr>', desc = '[D]iff [V]iew open' },
    { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = '[D]iff [V]iew [C]lose' },
    { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iff [H]istory (current file)' },
    { '<leader>dH', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iff [H]istory (all files)' },
  },
  config = function()
    local actions = require 'diffview.actions'

    require('diffview').setup {
      -- ======================================================================
      -- Diff View Configuration
      -- ======================================================================

      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = true, -- Better diff highlighting

      -- Use icons (requires nvim-web-devicons)
      use_icons = true,

      -- Show which commit(s) diffs are against
      show_help_hints = true,

      -- Watch for file changes and update automatically
      watch_index = true,

      -- ======================================================================
      -- Key Mappings
      -- ======================================================================

      keymaps = {
        disable_defaults = false, -- Disable default keymaps

        view = {
          -- Keymaps in diff view
          { 'n', '<tab>', actions.select_next_entry, { desc = 'Next file' } },
          { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Previous file' } },
          { 'n', 'gf', actions.goto_file_edit, { desc = 'Open file' } },
          { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open in split' } },
          { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open in tab' } },
          { 'n', '<leader>e', actions.focus_files, { desc = 'Focus file panel' } },
          { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle file panel' } },
          { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle layout' } },
          { 'n', '[x', actions.prev_conflict, { desc = 'Previous conflict' } },
          { 'n', ']x', actions.next_conflict, { desc = 'Next conflict' } },
          { 'n', '<leader>co', actions.conflict_choose 'ours', { desc = 'Choose ours' } },
          { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Choose theirs' } },
          { 'n', '<leader>cb', actions.conflict_choose 'both', { desc = 'Choose both' } },
          { 'n', '<leader>cB', actions.conflict_choose 'base', { desc = 'Choose base' } },
          { 'n', '<leader>cA', actions.conflict_choose_all 'ours', { desc = 'Choose all ours' } },
          { 'n', '<leader>cx', actions.conflict_choose 'none', { desc = 'Delete conflict' } },
        },

        diff1 = {
          -- Keymaps in single file diff (e.g., DiffviewFileHistory)
          { 'n', 'g?', actions.help { 'view', 'diff1' }, { desc = 'Open help' } },
        },

        diff2 = {
          -- Keymaps in 2-way diff
          { 'n', 'g?', actions.help { 'view', 'diff2' }, { desc = 'Open help' } },
        },

        diff3 = {
          -- Keymaps in 3-way diff (merge conflicts)
          { 'n', 'g?', actions.help { 'view', 'diff3' }, { desc = 'Open help' } },
        },

        diff4 = {
          -- Keymaps in 4-way diff
          { 'n', 'g?', actions.help { 'view', 'diff4' }, { desc = 'Open help' } },
        },

        file_panel = {
          -- Keymaps in file panel
          { 'n', 'j', actions.next_entry, { desc = 'Next file' } },
          { 'n', '<down>', actions.next_entry, { desc = 'Next file' } },
          { 'n', 'k', actions.prev_entry, { desc = 'Previous file' } },
          { 'n', '<up>', actions.prev_entry, { desc = 'Previous file' } },
          { 'n', '<cr>', actions.select_entry, { desc = 'Open diff' } },
          { 'n', 'o', actions.select_entry, { desc = 'Open diff' } },
          { 'n', 'l', actions.select_entry, { desc = 'Open diff' } },
          { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open diff' } },
          { 'n', '-', actions.toggle_stage_entry, { desc = 'Stage/unstage' } },
          { 'n', 'S', actions.stage_all, { desc = 'Stage all' } },
          { 'n', 'U', actions.unstage_all, { desc = 'Unstage all' } },
          { 'n', 'X', actions.restore_entry, { desc = 'Restore file' } },
          { 'n', 'L', actions.open_commit_log, { desc = 'Open commit log' } },
          { 'n', 'R', actions.refresh_files, { desc = 'Refresh files' } },
          { 'n', 'gf', actions.goto_file_edit, { desc = 'Open file' } },
          { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open in split' } },
          { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open in tab' } },
          { 'n', 'i', actions.listing_style, { desc = 'Toggle listing style' } },
          { 'n', 'f', actions.toggle_flatten_dirs, { desc = 'Toggle flatten dirs' } },
          { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle layout' } },
          { 'n', '[x', actions.prev_conflict, { desc = 'Previous conflict' } },
          { 'n', ']x', actions.next_conflict, { desc = 'Next conflict' } },
          { 'n', 'g?', actions.help 'file_panel', { desc = 'Open help' } },
        },

        file_history_panel = {
          -- Keymaps in file history panel
          { 'n', 'g!', actions.options, { desc = 'Open options' } },
          { 'n', '<C-A-d>', actions.open_in_diffview, { desc = 'Open in diffview' } },
          { 'n', 'y', actions.copy_hash, { desc = 'Copy commit hash' } },
          { 'n', 'L', actions.open_commit_log, { desc = 'Open commit log' } },
          { 'n', 'X', actions.restore_entry, { desc = 'Restore file' } },
          { 'n', 'g?', actions.help 'file_history_panel', { desc = 'Open help' } },
        },

        option_panel = {
          -- Keymaps in option panel
          { 'n', '<tab>', actions.select_entry, { desc = 'Select' } },
          { 'n', 'q', actions.close, { desc = 'Close' } },
          { 'n', 'g?', actions.help 'option_panel', { desc = 'Open help' } },
        },

        help_panel = {
          -- Keymaps in help panel
          { 'n', 'q', actions.close, { desc = 'Close' } },
          { 'n', '<esc>', actions.close, { desc = 'Close' } },
        },
      },

      -- ======================================================================
      -- View Configuration
      -- ======================================================================

      view = {
        -- Configure the layout
        default = {
          layout = 'diff2_horizontal', -- 'diff2_horizontal' | 'diff2_vertical'
          winbar_info = true, -- Show file info in winbar
        },
        merge_tool = {
          layout = 'diff3_horizontal', -- 3-way diff for merge conflicts
          disable_diagnostics = true, -- Disable LSP diagnostics in diff
          winbar_info = true,
        },
        file_history = {
          layout = 'diff2_horizontal',
          winbar_info = true,
        },
      },

      -- ======================================================================
      -- File Panel Configuration
      -- ======================================================================

      file_panel = {
        listing_style = 'tree', -- 'list' | 'tree'
        tree_options = {
          flatten_dirs = true, -- Flatten single-child directories
          folder_statuses = 'only_folded', -- Show git status for folders
        },
        win_config = {
          position = 'left', -- 'left' | 'right' | 'top' | 'bottom'
          width = 35, -- Panel width
          win_opts = {},
        },
      },

      -- ======================================================================
      -- Commit Log Configuration
      -- ======================================================================

      commit_log_panel = {
        win_config = {
          win_opts = {},
        },
      },

      -- ======================================================================
      -- Hooks
      -- ======================================================================

      hooks = {
        -- Called when diffview is opened
        -- diff_buf_read = function(bufnr)
        --   vim.opt_local.wrap = false
        --   vim.opt_local.list = false
        -- end,

        -- Called when entering a diff buffer
        -- view_opened = function(view)
        --   print("Diffview opened: " .. view.class:name())
        -- end,
      },
    }
  end,
}
