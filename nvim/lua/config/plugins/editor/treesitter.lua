-- ===========================================================================
-- Treesitter - Syntax Highlighting and Code Understanding
-- ===========================================================================
--
-- Treesitter provides better syntax highlighting, indentation, and code
-- understanding by building a syntax tree of your code. This enables more
-- accurate highlighting and smart text objects.
--
-- Features:
--   - Advanced syntax highlighting
--   - Incremental parsing for performance
--   - Smart indentation
--   - Automatic language installation
--   - Code folding support
--   - Integration with other plugins
--
-- Languages:
--   Automatically installed: bash, c, diff, html, lua, luadoc, markdown,
--   markdown_inline, query, vim, vimdoc
--
--   Additional languages are auto-installed when you open files of that type.
--
-- Commands:
--   :TSInstall <language>    - Install a language parser
--   :TSUpdate                - Update all installed parsers
--   :TSUninstall <language>  - Uninstall a language parser
--   :TSInstallInfo           - Show installed parsers
--
-- For more info:
--   :help nvim-treesitter
--   :help treesitter
--   https://github.com/nvim-treesitter/nvim-treesitter
--
-- Related plugins to explore:
--   - nvim-treesitter-context: Show code context at top of window
--   - nvim-treesitter-textobjects: Smart text objects based on syntax
--   - Incremental selection: Built-in, see :help nvim-treesitter-incremental-selection-mod
--
-- ===========================================================================

return {
  'nvim-treesitter/nvim-treesitter',

  -- Run :TSUpdate after installation or update
  build = ':TSUpdate',

  -- Use nvim-treesitter.configs as the main module for setup
  main = 'nvim-treesitter.configs',

  opts = {
    -- ========================================================================
    -- Parser Installation
    -- ========================================================================

    -- List of parsers that should always be installed
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    },

    -- Automatically install missing parsers when entering buffer
    -- This means if you open a Python file and the Python parser isn't
    -- installed, it will automatically install it for you
    auto_install = true,

    -- ========================================================================
    -- Syntax Highlighting
    -- ========================================================================

    highlight = {
      -- Enable Treesitter-based syntax highlighting
      enable = true,

      -- Some languages depend on Vim's regex highlighting system (such as Ruby)
      -- for indent rules. If you are experiencing weird indenting issues,
      -- add the language to this list.
      additional_vim_regex_highlighting = { 'ruby' },
    },

    -- ========================================================================
    -- Indentation
    -- ========================================================================

    indent = {
      -- Enable Treesitter-based indentation
      enable = true,

      -- Disable for languages that have issues with Treesitter indentation
      disable = { 'ruby' },
    },
  },
}
