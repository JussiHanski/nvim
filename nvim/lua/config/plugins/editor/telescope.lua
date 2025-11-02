-- ===========================================================================
-- Telescope - Fuzzy Finder
-- ===========================================================================
--
-- Telescope is a highly extendable fuzzy finder over lists. It can search
-- files, grep content, browse LSP symbols, git files, and much more.
--
-- Features:
--   - Fast fuzzy finding with live preview
--   - Search files, buffers, help tags, and more
--   - Integrated LSP support (symbols, references, definitions)
--   - Live grep across your project
--   - Extensible with custom pickers
--   - UI customization with themes
--
-- Keybindings:
--   <leader>sh  - [S]earch [H]elp documentation
--   <leader>sk  - [S]earch [K]eymaps
--   <leader>sf  - [S]earch [F]iles
--   <leader>ss  - [S]earch [S]elect Telescope pickers
--   <leader>sw  - [S]earch current [W]ord
--   <leader>sg  - [S]earch by [G]rep (live grep)
--   <leader>sd  - [S]earch [D]iagnostics
--   <leader>sr  - [S]earch [R]esume (resume last search)
--   <leader>s.  - [S]earch Recent Files
--   <leader><leader> - Find existing buffers
--   <leader>/   - Fuzzily search in current buffer
--   <leader>s/  - [S]earch [/] in Open Files
--   <leader>sn  - [S]earch [N]eovim config files
--
-- Telescope Keybindings (while in picker):
--   Insert mode:
--     <C-/>     - Show help/keybindings
--     <C-n>     - Next item
--     <C-p>     - Previous item
--   Normal mode:
--     ?         - Show help/keybindings
--     j/k       - Next/Previous item
--     gg/G      - First/Last item
--
-- For more info:
--   :help telescope
--   :help telescope.builtin
--   https://github.com/nvim-telescope/telescope.nvim
--
-- ===========================================================================

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter', -- Load when Neovim starts

  dependencies = {
    'nvim-lua/plenary.nvim', -- Required dependency

    { -- FZF native for better performance
      'nvim-telescope/telescope-fzf-native.nvim',
      -- Build the native FZF sorter (requires make)
      build = 'make',
      -- Only install if make is available
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- UI select integration - use Telescope for vim.ui.select
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Pretty icons (requires Nerd Font)
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    -- ========================================================================
    -- Telescope Setup
    -- ========================================================================

    require('telescope').setup {
      -- You can customize default mappings and behavior here
      -- See :help telescope.setup()
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- ========================================================================
    -- Load Extensions
    -- ========================================================================

    -- Enable FZF extension for better performance (if available)
    pcall(require('telescope').load_extension, 'fzf')

    -- Enable UI select extension for better vim.ui.select interface
    pcall(require('telescope').load_extension, 'ui-select')

    -- ========================================================================
    -- Keybindings
    -- ========================================================================

    local builtin = require 'telescope.builtin'

    -- Search help documentation
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

    -- Search keymaps
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })

    -- Search files in current working directory
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })

    -- Search and select from all available Telescope pickers
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

    -- Search for the word currently under cursor
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

    -- Live grep - search for text across all files
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })

    -- Search diagnostics (errors, warnings, etc.)
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

    -- Resume the last Telescope search
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

    -- Search recently opened files
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

    -- List and search through open buffers
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Fuzzy search in current buffer
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Live grep in open files only
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Search Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
