-- Claude Code Integration
-- Embeds Claude Code directly into Neovim as a terminal window.
-- Provides AI-assisted coding with automatic file reload and context management.
--
-- Keybindings:
--   <leader>cc or Ctrl+, : Toggle Claude Code terminal
--   Ctrl+.               : Continue previous conversation
--   <leader>ca           : Add current file to Claude context with @
--   <leader>cA           : Add all open files to Claude context
--
-- Features:
--   - Terminal opens as vertical split (40% width) on right side
--   - Automatic file refresh when Claude Code modifies files
--   - Git root detection for multi-instance support
--   - Side-by-side editing with AI assistance

return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('claude-code').setup {
      -- Terminal window configuration
      window = {
        position = 'botright vsplit', -- Vertical split on the right
        split_ratio = 0.4, -- 40% of screen width
        enter_insert = true,
        start_in_normal_mode = false,
        hide_numbers = true,
        hide_signcolumn = true,
        float = {
          relative = 'editor',
          width = '80%',
          height = '80%',
          row = 'center',
          col = 'center',
          border = 'rounded',
        },
      },

      -- File refresh settings
      refresh = {
        enable = true,
        updatetime = 100,
        timer_interval = 1000,
        show_notifications = true,
      },

      -- Git integration
      git = {
        use_git_root = true,
        multi_instance = true,
      },

      -- Keymaps (set to false to disable)
      keymaps = {
        toggle = {
          normal = false, -- Disabled, using manual keymaps below
          terminal = false, -- Disabled, using manual keymaps below
        },
        window_navigation = true,
        scrolling = true,
      },
    }

    -- Add custom commands for IDE integration
    -- Add command to add current file to Claude Code context with @
    vim.api.nvim_create_user_command('ClaudeAddFile', function()
      -- Get the current file path relative to cwd
      local filepath = vim.fn.expand '%:.'
      if filepath == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end

      -- Get Claude Code terminal buffer
      local claude_code = require 'claude-code'
      if not claude_code.claude_code or not claude_code.claude_code.instances then
        vim.notify('Claude Code not running. Start with <leader>cc first.', vim.log.levels.WARN)
        return
      end

      local current_instance = claude_code.claude_code.current_instance
      local bufnr = claude_code.claude_code.instances[current_instance]

      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        vim.notify('Claude Code terminal not found', vim.log.levels.WARN)
        return
      end

      -- Send @ command with current file
      local chan_id = vim.b[bufnr].terminal_job_id
      if chan_id then
        vim.fn.chansend(chan_id, '@' .. filepath .. ' ')
        vim.notify('Added file to context: ' .. filepath, vim.log.levels.INFO)
      end
    end, { desc = 'Add current file to Claude Code with @' })

    -- Add command to add all open buffers to Claude Code context with @
    vim.api.nvim_create_user_command('ClaudeAddAllFiles', function()
      local claude_code = require 'claude-code'
      if not claude_code.claude_code or not claude_code.claude_code.instances then
        vim.notify('Claude Code not running. Start with <leader>cc first.', vim.log.levels.WARN)
        return
      end

      local current_instance = claude_code.claude_code.current_instance
      local bufnr = claude_code.claude_code.instances[current_instance]

      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        vim.notify('Claude Code terminal not found', vim.log.levels.WARN)
        return
      end

      -- Get all valid file buffers (relative paths)
      local cwd = vim.fn.getcwd()
      local files = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
          local filepath = vim.api.nvim_buf_get_name(buf)
          if filepath ~= '' and vim.fn.filereadable(filepath) == 1 then
            -- Convert to relative path
            local relpath = vim.fn.fnamemodify(filepath, ':.')
            table.insert(files, '@' .. relpath)
          end
        end
      end

      if #files == 0 then
        vim.notify('No files open', vim.log.levels.WARN)
        return
      end

      -- Send @ commands with all files
      local chan_id = vim.b[bufnr].terminal_job_id
      if chan_id then
        vim.fn.chansend(chan_id, table.concat(files, ' ') .. ' ')
        vim.notify('Added ' .. #files .. ' file(s) to context', vim.log.levels.INFO)
      end
    end, { desc = 'Add all open buffers to Claude Code with @' })

    -- Add keymaps for adding files to context
    vim.keymap.set('n', '<leader>ca', '<cmd>ClaudeAddFile<cr>', { desc = '[C]laude [A]dd current file (@)' })
    vim.keymap.set('n', '<leader>cA', '<cmd>ClaudeAddAllFiles<cr>', { desc = '[C]laude [A]dd all open files (@)' })
  end,
  keys = {
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = '[C]laude [C]ode Toggle', mode = 'n' },
    { '<C-,>', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code', mode = 'n' },
    { '<C-.>', '<cmd>ClaudeCodeContinue<cr>', desc = 'Continue Claude Code', mode = 'n' },
  },
}
