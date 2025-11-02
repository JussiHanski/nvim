-- ===========================================================================
-- Mason - LSP/DAP/Linter/Formatter Package Manager
-- ===========================================================================
--
-- Mason is a package manager for Neovim that makes it easy to install and
-- manage LSP servers, DAP servers, linters, and formatters. It provides a
-- graphical interface and automatic installation capabilities.
--
-- Features:
--   - Easy installation of LSP servers and tools
--   - Cross-platform support
--   - Automatic updates
--   - Integration with nvim-lspconfig
--   - Graphical interface for managing packages
--
-- Commands:
--   :Mason              - Open Mason UI to browse and install packages
--   :MasonInstall <pkg> - Install a package
--   :MasonUninstall <pkg> - Uninstall a package
--   :MasonUpdate        - Update all installed packages
--   :MasonLog           - Open Mason log file
--
-- Mason UI Keybindings:
--   i  - Install package under cursor
--   u  - Update package under cursor
--   X  - Uninstall package under cursor
--   g? - Show help
--
-- For more info:
--   :help mason.nvim
--   :help mason-lspconfig
--   https://github.com/williamboman/mason.nvim
--
-- ===========================================================================

return {
  'mason-org/mason.nvim',

  -- Mason provides the base package manager functionality
  -- No specific configuration needed - just enable it
  opts = {},
}
