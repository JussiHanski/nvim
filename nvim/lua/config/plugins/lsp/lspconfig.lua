-- ===========================================================================
-- LSP Configuration - Language Server Protocol
-- ===========================================================================
--
-- LSP (Language Server Protocol) enables features like:
--   - Go to definition
--   - Find references
--   - Autocompletion
--   - Symbol search
--   - Code actions (refactoring, import organization, etc.)
--   - Inline diagnostics (errors, warnings)
--   - Hover documentation
--   - Signature help
--   - Code formatting
--
-- LSP Servers are standalone processes that understand programming languages
-- and provide intelligence to Neovim. Each language typically has its own
-- server (e.g., lua_ls for Lua, clangd for C/C++, rust_analyzer for Rust).
--
-- Keybindings (available when LSP is active):
--   <leader>rn  - [R]e[n]ame: Rename symbol under cursor
--   <leader>rp  - [R]ename [P]roject-wide: Search occurrences first
--   <leader>ca  - [C]ode [A]ction: Show available code actions
--   gr          - [G]oto [R]eferences: Show all references
--   gd          - [G]oto [D]efinition: Jump to definition
--   gD          - [G]oto [D]eclaration: Jump to declaration (e.g., header)
--   gI          - [G]oto [I]mplementation: Jump to implementation
--   gy          - [G]oto T[y]pe Definition: Jump to type definition
--   gO          - Open Document Symbols: List all symbols in file
--   gW          - Open Workspace Symbols: Search symbols in project
--   gh          - [G]oto [H]eader/Source: Switch between .h and .cpp (clangd only)
--   <leader>th  - [T]oggle Inlay [H]ints: Show/hide inline type hints
--
-- Diagnostic Keybindings:
--   [d / ]d     - Previous/Next diagnostic
--   <leader>q   - Open diagnostic quickfix list
--
-- For more info:
--   :help lsp
--   :help lspconfig
--   :help lsp-vs-treesitter
--
-- ===========================================================================

return {
  'neovim/nvim-lspconfig',

  dependencies = {
    -- Mason must be loaded before lspconfig
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP operations
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },

  config = function()
    -- ========================================================================
    -- LSP Attach Autocommand
    -- ========================================================================
    --
    -- This function runs whenever an LSP attaches to a buffer.
    -- It sets up keybindings and behavior specific to that buffer.
    --
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        -- =====================================================================
        -- Helper Functions
        -- =====================================================================

        -- Helper function to create buffer-local keymaps
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Helper to check if LSP client supports a method
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- =====================================================================
        -- LSP Keybindings
        -- =====================================================================

        -- Rename the symbol under cursor
        -- Most Language Servers support renaming across files
        -- For C/C++: Ensure you have compile_commands.json in your project root
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Project-wide search and replace for symbols (including macros)
        -- This uses Telescope to show all occurrences first, then you can use
        -- quickfix for replacement
        map('<leader>rp', function()
          local word = vim.fn.expand('<cword>')
          require('telescope.builtin').grep_string({
            search = word,
            prompt_title = 'Project-wide occurrences of: ' .. word,
          })
        end, '[R]ename [P]roject-wide (search first)')

        -- Execute a code action
        -- Code actions are contextual suggestions from the LSP, such as:
        --   - Auto-import missing symbols
        --   - Extract to function/variable
        --   - Implement interface methods
        --   - Fix common issues
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- Find all references to the symbol under cursor
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to implementation (useful for interfaces/abstract classes)
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to where the symbol was defined
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Jump to declaration (e.g., header file in C/C++)
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- List all symbols in the current document
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Search symbols across the entire workspace
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to type definition
        -- Useful when you want to see the definition of a variable's type
        map('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto T[y]pe Definition')

        -- =====================================================================
        -- LSP Client-Specific Features
        -- =====================================================================

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Document highlight: Highlight references under cursor
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

          -- Highlight references when cursor stays still
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Clear highlights when cursor moves
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          -- Clean up when LSP detaches
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints: Show inline type information
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Clangd-specific: Switch between header and source files
        if client and client.name == 'clangd' then
          map('gh', function()
            local params = { uri = vim.uri_from_bufnr(0) }
            client.request('textDocument/switchSourceHeader', params, function(err, result)
              if err then
                vim.notify('Error switching source/header: ' .. err.message, vim.log.levels.ERROR)
                return
              end
              if not result then
                vim.notify('Corresponding file not found', vim.log.levels.WARN)
                return
              end
              vim.cmd.edit(vim.uri_to_fname(result))
            end)
          end, '[G]oto [H]eader/Source')
        end
      end,
    })

    -- ========================================================================
    -- Diagnostic Configuration
    -- ========================================================================

    vim.diagnostic.config {
      -- Sort diagnostics by severity (errors first)
      severity_sort = true,

      -- Floating window configuration
      float = { border = 'rounded', source = 'if_many' },

      -- Only show underlines for errors (not warnings/info/hints)
      underline = { severity = vim.diagnostic.severity.ERROR },

      -- Sign column icons (requires Nerd Font)
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},

      -- Virtual text configuration (inline diagnostics)
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    }

    -- ========================================================================
    -- LSP Server Configuration
    -- ========================================================================

    -- Get capabilities from blink.cmp for better completion
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- LSP server configurations
    -- Add or remove servers here. They will be automatically installed via Mason.
    local servers = {
      -- Clangd (C/C++)
      -- For best cross-file features, ensure you have compile_commands.json:
      --   CMake: cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
      --   Make: bear -- make
      --   Other: Use compiledb or similar tools
      clangd = {
        cmd = {
          'clangd',
          '--background-index',          -- Index project in background
          '--clang-tidy',                 -- Enable clang-tidy checks
          '--header-insertion=iwyu',      -- Smart header insertion
          '--completion-style=detailed',  -- More detailed completions
          '--function-arg-placeholders',  -- Placeholder arguments
          '--fallback-style=llvm',        -- Code style fallback
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },

      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- Uncomment to ignore noisy 'missing-fields' warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },

      -- Add more servers here:
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ts_ls = {},
      --
      -- See :help lspconfig-all for all available servers
    }

    -- ========================================================================
    -- Mason Tool Installation
    -- ========================================================================

    -- Ensure LSP servers and tools are installed
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Lua formatter
    })

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    -- ========================================================================
    -- Mason LSP Configuration
    -- ========================================================================

    require('mason-lspconfig').setup {
      -- Don't use ensure_installed here - we use mason-tool-installer instead
      ensure_installed = {},
      automatic_installation = false,

      -- Setup handler for all installed servers
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- Merge capabilities with server-specific ones
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
