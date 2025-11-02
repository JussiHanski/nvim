-- ===========================================================================
-- GitHub Copilot - AI-powered code completion
-- ===========================================================================
--
-- GitHub Copilot provides AI-powered inline code suggestions as you type.
-- It uses OpenAI Codex to suggest entire lines or blocks of code based on
-- context from your current file and other open files.
--
-- Features:
--   - Inline code suggestions in insert mode
--   - Multi-line completions
--   - Context-aware suggestions
--   - Support for multiple programming languages
--   - Copilot panel for browsing multiple suggestions
--
-- Keybindings (Insert mode):
--   <M-l>       - Accept the current suggestion
--   <M-]>       - Cycle to next suggestion
--   <M-[>       - Cycle to previous suggestion
--   <M-BS>      - Dismiss the current suggestion
--
-- Keybindings (Normal mode):
--   <leader>cp  - Open Copilot panel to browse suggestions
--
-- Commands:
--   :Copilot    - Show Copilot status and available commands
--   :Copilot panel - Open the Copilot panel
--   :Copilot enable - Enable Copilot
--   :Copilot disable - Disable Copilot
--
-- For more info:
--   :help copilot
--   https://github.com/github/copilot.vim
--
-- ===========================================================================

return {
  'github/copilot.vim',
  event = 'InsertEnter', -- Load when entering insert mode for the first time

  config = function()
    -- ========================================================================
    -- Basic Configuration
    -- ========================================================================

    -- Disable default tab mapping to avoid conflicts with other completion plugins
    vim.g.copilot_no_tab_map = true

    -- Tell Copilot that we'll be using custom mappings
    vim.g.copilot_assume_mapped = true

    -- Enable Copilot for all filetypes by default
    -- You can customize this to disable Copilot for specific filetypes:
    -- vim.g.copilot_filetypes = { markdown = false, text = false }
    vim.g.copilot_filetypes = vim.tbl_extend('force', {
      ['*'] = true,
    }, vim.g.copilot_filetypes or {})

    -- ========================================================================
    -- Keybindings
    -- ========================================================================

    -- Helper function to create insert mode keymaps with proper options
    local map = function(lhs, rhs, desc)
      vim.keymap.set('i', lhs, rhs, {
        expr = true,        -- Evaluate the mapping as an expression
        silent = true,      -- Don't show the command in the command line
        replace_keycodes = false, -- Don't replace keycodes in the expression
        desc = desc,
      })
    end

    -- Accept the current Copilot suggestion
    map('<M-l>', function()
      return vim.fn['copilot#Accept'] ''
    end, 'Copilot Accept')

    -- Cycle to the next Copilot suggestion
    map('<M-]>', function()
      return vim.fn['copilot#Next']()
    end, 'Copilot Next')

    -- Cycle to the previous Copilot suggestion
    map('<M-[>', function()
      return vim.fn['copilot#Previous']()
    end, 'Copilot Previous')

    -- Dismiss the current Copilot suggestion
    map('<M-BS>', function()
      return vim.fn['copilot#Dismiss']()
    end, 'Copilot Dismiss')

    -- Open Copilot panel to browse multiple suggestions
    vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<cr>', { desc = '[C]opilot [P]anel' })
  end,
}
