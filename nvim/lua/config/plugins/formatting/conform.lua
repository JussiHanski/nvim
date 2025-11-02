-- ===========================================================================
-- Conform - Code Formatting
-- ===========================================================================
--
-- Conform is a lightweight and fast formatter plugin that supports multiple
-- formatters per filetype and provides format-on-save functionality.
--
-- Features:
--   - Fast asynchronous formatting
--   - Multiple formatters per filetype
--   - Format-on-save with LSP fallback
--   - Range formatting support
--   - Conditional formatting based on filetype
--   - Integration with Mason for formatter installation
--
-- Keybindings:
--   <leader>f  - Format the current buffer
--
-- Commands:
--   :ConformInfo  - Show information about formatters for current buffer
--   :Format       - Format the current buffer (custom command)
--
-- How it works:
--   1. First tries to use configured formatters for the filetype
--   2. Falls back to LSP formatting if no formatters are configured
--   3. Can run multiple formatters sequentially
--
-- Supported Formatters (examples):
--   - stylua:       Lua code formatter
--   - prettier:     JavaScript, TypeScript, HTML, CSS, JSON, etc.
--   - black:        Python code formatter
--   - isort:        Python import sorter
--   - clang-format: C, C++, Java formatter
--   - rustfmt:      Rust formatter
--   - gofmt:        Go formatter
--
-- For more info:
--   :help conform.nvim
--   https://github.com/stevearc/conform.nvim
--
-- ===========================================================================

return {
  'stevearc/conform.nvim',

  -- Load when about to write a file or when ConformInfo is called
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },

  -- ========================================================================
  -- Format Keybinding
  -- ========================================================================

  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,        -- Format asynchronously
          lsp_format = 'fallback', -- Use LSP if no formatter configured
        }
      end,
      mode = '',               -- Works in normal and visual mode
      desc = '[F]ormat buffer',
    },
  },

  opts = {
    -- ========================================================================
    -- General Settings
    -- ========================================================================

    -- Don't show error notifications (they appear in command line instead)
    notify_on_error = false,

    -- ========================================================================
    -- Format on Save
    -- ========================================================================

    -- Function to determine format-on-save behavior per filetype
    format_on_save = function(bufnr)
      -- Disable format-on-save for languages without standardized style
      -- You can add more filetypes here or remove this restriction
      local disable_filetypes = {
        c = true,    -- C often has project-specific formatting
        cpp = true,  -- C++ often has project-specific formatting
      }

      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil  -- Don't format on save
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback', -- Use LSP if no formatter configured
        }
      end
    end,

    -- ========================================================================
    -- Formatter Configuration
    -- ========================================================================

    -- Map filetypes to formatters
    -- Formatters are run in the order specified
    formatters_by_ft = {
      -- Lua
      lua = { 'stylua' },

      -- Python (run isort, then black)
      -- python = { 'isort', 'black' },

      -- JavaScript/TypeScript (use first available formatter)
      -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- typescript = { 'prettierd', 'prettier', stop_after_first = true },

      -- HTML/CSS
      -- html = { 'prettier' },
      -- css = { 'prettier' },

      -- JSON
      -- json = { 'prettier' },

      -- YAML
      -- yaml = { 'prettier' },

      -- Markdown
      -- markdown = { 'prettier' },

      -- Go
      -- go = { 'gofmt' },

      -- Rust
      -- rust = { 'rustfmt' },

      -- C/C++
      -- c = { 'clang-format' },
      -- cpp = { 'clang-format' },

      -- Add more formatters here as needed
      -- See :help conform-formatters for the full list of built-in formatters
    },

    -- ========================================================================
    -- Custom Formatter Configuration
    -- ========================================================================

    -- You can customize how formatters are run
    -- formatters = {
    --   stylua = {
    --     -- Override command-line arguments
    --     prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
    --   },
    -- },
  },
}
