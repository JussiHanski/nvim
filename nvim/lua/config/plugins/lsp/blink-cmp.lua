-- ===========================================================================
-- Blink.cmp - Fast Autocompletion Engine
-- ===========================================================================
--
-- Blink.cmp is a modern, fast autocompletion plugin that provides intelligent
-- code completion as you type. It integrates with LSP servers, snippets, and
-- other sources to provide context-aware suggestions.
--
-- Features:
--   - Fast and responsive completion
--   - LSP integration
--   - Snippet support (via LuaSnip)
--   - File path completion
--   - Automatic documentation popup
--   - Signature help
--   - Fuzzy matching
--   - Optional Rust implementation for better performance
--
-- Keybindings (Insert mode):
--   <C-y>       - Accept completion ([y]es)
--   <C-e>       - Hide completion menu
--   <C-n>       - Next completion item
--   <C-p>       - Previous completion item
--   <Up>/<Down> - Next/Previous completion item
--   <C-space>   - Open menu or show documentation
--   <C-k>       - Toggle signature help
--   <Tab>       - Move to next snippet field
--   <S-Tab>     - Move to previous snippet field
--
-- Completion Sources:
--   - LSP: Language server completions
--   - Path: File path completions
--   - Snippets: Code snippets (via LuaSnip)
--   - Lazydev: Neovim Lua API completions
--
-- For more info:
--   :help blink.cmp
--   https://github.com/saghen/blink.cmp
--
-- ===========================================================================

return {
  'saghen/blink.cmp',
  event = 'VimEnter', -- Load when Neovim starts
  version = '1.*',    -- Use stable version 1.x

  dependencies = {
    -- ========================================================================
    -- Snippet Engine
    -- ========================================================================
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',

      -- Build regex support for snippets (if make is available)
      build = (function()
        -- Skip build on Windows or when make is not available
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),

      dependencies = {
        -- Friendly-snippets: Pre-made snippets for many languages
        -- Uncomment to enable:
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },

      opts = {},
    },

    -- Integration with lazydev for Neovim Lua API completions
    'folke/lazydev.nvim',
  },

  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    -- ========================================================================
    -- Keymap Configuration
    -- ========================================================================

    keymap = {
      -- Keymap preset options:
      --   'default' (recommended): <c-y> to accept
      --     - Auto-imports if LSP supports it
      --     - Expands snippets
      --   'super-tab': <tab> to accept
      --   'enter': <enter> to accept
      --   'none': No default mappings
      --
      -- For understanding why 'default' is recommended, read:
      --   :help ins-completion
      --
      -- All presets include these mappings:
      --   <tab>/<s-tab>: Move between snippet fields
      --   <c-space>: Open menu or show docs
      --   <c-n>/<c-p> or <up>/<down>: Select next/previous item
      --   <c-e>: Hide menu
      --   <c-k>: Toggle signature help
      --
      -- See :help blink-cmp-config-keymap for custom keymaps
      preset = 'default',

      -- For more advanced LuaSnip keymaps (choice nodes, expansion), see:
      --   https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    -- ========================================================================
    -- Appearance
    -- ========================================================================

    appearance = {
      -- Font variant for icons:
      --   'mono': For 'Nerd Font Mono'
      --   'normal': For 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- ========================================================================
    -- Completion Behavior
    -- ========================================================================

    completion = {
      -- Documentation window behavior
      -- By default, press <c-space> to show documentation
      -- Optionally, set auto_show = true to show docs after a delay
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 500,
      },
    },

    -- ========================================================================
    -- Completion Sources
    -- ========================================================================

    sources = {
      -- Default sources that will be used for completion
      default = { 'lsp', 'path', 'snippets', 'lazydev' },

      providers = {
        -- Lazydev: Enhanced Neovim Lua API completions
        -- Higher score_offset means higher priority
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    -- ========================================================================
    -- Snippet Configuration
    -- ========================================================================

    snippets = {
      preset = 'luasnip', -- Use LuaSnip as the snippet engine
    },

    -- ========================================================================
    -- Fuzzy Matching
    -- ========================================================================

    -- Blink.cmp includes an optional Rust fuzzy matcher for better performance
    -- It automatically downloads a prebuilt binary when enabled
    --
    -- Options:
    --   'lua': Lua implementation (default, no dependencies)
    --   'prefer_rust_with_warning': Try Rust, fall back to Lua with warning
    --
    -- See :help blink-cmp-config-fuzzy for more information
    fuzzy = {
      implementation = 'lua',
    },

    -- ========================================================================
    -- Signature Help
    -- ========================================================================

    -- Shows a signature help window while typing function arguments
    signature = {
      enabled = true,
    },
  },
}
