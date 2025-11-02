-- ===========================================================================
-- Lazygit - Full-featured Git TUI in Neovim
-- ===========================================================================
--
-- Lazygit is a terminal UI for git that provides a beautiful, fast interface
-- for all git operations. This plugin embeds it in a Neovim floating window.
--
-- Features:
--   - Full git workflow in a TUI (commits, branches, rebases, stashes)
--   - Visual branch tree and commit history
--   - Interactive staging and unstaging
--   - Merge conflict resolution
--   - Cherry-picking, rebasing, amending
--   - Push/pull operations
--   - Submodule management
--
-- Prerequisites:
--   Install lazygit: https://github.com/jesseduffield/lazygit
--
--   macOS:       brew install lazygit
--   Ubuntu:      sudo add-apt-repository ppa:lazygit-team/release
--                sudo apt update && sudo apt install lazygit
--   Arch:        sudo pacman -S lazygit
--   Windows:     choco install lazygit / scoop install lazygit
--
-- Keybindings:
--   <leader>gg  : Open lazygit in floating window
--   <leader>gf  : Open lazygit for current file
--   <leader>gc  : Open lazygit commit log
--
-- Inside Lazygit (basic commands):
--   Tab         : Switch between panels
--   j/k         : Navigate up/down
--   Space       : Stage/unstage file or hunk
--   c           : Commit
--   P           : Push
--   p           : Pull
--   [/]         : Navigate tabs (Status, Files, Branches, Commits, Stash)
--   x           : Open command menu
--   ?           : Toggle help
--   q           : Quit
--
-- For more info:
--   :help lazygit.nvim
--   https://github.com/jesseduffield/lazygit
--   https://github.com/kdheepak/lazygit.nvim
--
-- ===========================================================================

return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open Lazy[G]it' },
    { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'Lazy[G]it current [F]ile' },
    { '<leader>gc', '<cmd>LazyGitFilter<cr>', desc = 'Lazy[G]it [C]ommit log' },
  },
  config = function()
    -- Optional: Configure lazygit appearance
    -- Set to 1 to use floating window
    vim.g.lazygit_floating_window_winblend = 0 -- Transparency (0-100)
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Window size (0.0-1.0)
    vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    vim.g.lazygit_floating_window_use_plenary = 1 -- Use plenary for better window management

    -- Optional: Use nvr (neovim-remote) to edit commit messages in current Neovim instance
    -- Install with: pip install neovim-remote
    -- vim.g.lazygit_use_neovim_remote = 1
  end,
}
