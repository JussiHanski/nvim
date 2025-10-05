# Installation Guide

Cross-platform installation guide for the Neovim Configuration Tool.

**Supported Platforms:**
- macOS
- Linux (Fedora, Ubuntu, Debian, Arch)
- Windows (PowerShell/cmd)
- Windows WSL2 (Ubuntu/Debian)

---

## macOS Installation

### Prerequisites

Install Homebrew if not already installed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Installation

1. **Clone and initialize:**
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/JussiHanski/nvim/main/bootstrap.sh) init
   ```

2. **The script will automatically:**
   - Check for git
   - Clone the repository to `~/.config/nvim_config_tool`
   - Offer to install missing dependencies via Homebrew
   - Install Neovim (if not present or upgrade if < 0.11)
   - Create symlink: `~/.config/nvim` → `nvim_config_tool/nvim`
   - Install plugins automatically

### Dependencies

**Critical (auto-installed if missing):**
- git
- make
- unzip
- gcc/clang
- ripgrep

**Optional (recommended):**
- fd
- cargo (Rust)
- node/npm

**Manual installation if needed:**
```bash
brew install git make unzip ripgrep fd rust node
```

---

## Linux Installation

### Fedora

1. **Install git:**
   ```bash
   sudo dnf install git
   ```

2. **Clone and initialize:**
   ```bash
   git clone https://github.com/JussiHanski/nvim.git ~/.config/nvim_config_tool
   cd ~/.config/nvim_config_tool
   bash bootstrap.sh init
   ```

3. **Install dependencies when prompted:**
   ```bash
   sudo dnf install make unzip gcc ripgrep fd-find cargo nodejs npm
   ```

4. **Install/upgrade Neovim (0.11+ required):**
   ```bash
   # Fedora 40+ has Neovim 0.11+
   sudo dnf install neovim

   # For older Fedora, use AppImage:
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
   chmod +x nvim.appimage
   sudo mv nvim.appimage /usr/local/bin/nvim
   ```

### Ubuntu/Debian

1. **Install git:**
   ```bash
   sudo apt-get update
   sudo apt-get install git
   ```

2. **Clone and initialize:**
   ```bash
   git clone https://github.com/JussiHanski/nvim.git ~/.config/nvim_config_tool
   cd ~/.config/nvim_config_tool
   bash bootstrap.sh init
   ```

3. **Install dependencies when prompted:**
   ```bash
   sudo apt-get install make unzip gcc ripgrep fd-find cargo nodejs npm
   ```

4. **Install/upgrade Neovim (0.11+ required):**

   **Option A: Homebrew (Recommended - easiest way to get latest version)**
   ```bash
   # Install Homebrew on Linux
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   # Add to PATH (follow instructions after install, or use these):
   echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

   # Install Neovim
   brew install neovim
   ```

   **Option B: Default repository (may be old version 0.10.x)**
   ```bash
   sudo apt-get install neovim
   ```

   **Option C: PPA or AppImage**
   ```bash
   # Unstable PPA:
   sudo add-apt-repository ppa:neovim-ppa/unstable
   sudo apt-get update
   sudo apt-get install neovim

   # OR use AppImage:
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
   chmod +x nvim.appimage
   sudo mv nvim.appimage /usr/local/bin/nvim
   ```

   The bootstrap script will automatically detect Homebrew and use it if available!

### Arch Linux

1. **Install and initialize:**
   ```bash
   sudo pacman -S git neovim make unzip gcc ripgrep fd rust nodejs npm
   git clone https://github.com/JussiHanski/nvim.git ~/.config/nvim_config_tool
   cd ~/.config/nvim_config_tool
   bash bootstrap.sh init
   ```

---

## Windows (PowerShell/cmd) Installation

### Prerequisites

**Install Git for Windows:**
- Download from: https://git-scm.com/download/win
- During installation, select "Git from the command line and also from 3rd-party software"
- Restart terminal after installation

### Installation

1. **Open PowerShell or Command Prompt and clone:**

   **PowerShell:**
   ```powershell
   git clone https://github.com/JussiHanski/nvim.git $env:USERPROFILE\.config\nvim_config_tool
   cd $env:USERPROFILE\.config\nvim_config_tool
   .\bootstrap.bat init
   ```

   **Command Prompt (cmd):**
   ```cmd
   git clone https://github.com/JussiHanski/nvim.git "%USERPROFILE%\.config\nvim_config_tool"
   cd "%USERPROFILE%\.config\nvim_config_tool"
   bootstrap.bat init
   ```

2. **The script will:**
   - Check for dependencies
   - Offer to install missing tools via winget (Windows Package Manager)
   - Install Neovim if needed
   - Create junction: `%LOCALAPPDATA%\nvim` → `nvim_config_tool\nvim`
   - Install plugins

### Dependencies

The script supports automatic installation via **winget** (Windows 10 1809+):

**Critical dependencies:**
- Git (Git.Git)
- Make (via MSYS2.MSYS2)
- Ripgrep (BurntSushi.ripgrep.MSVC)
- C Compiler (Microsoft.VisualStudio.2022.BuildTools)

**Optional dependencies:**
- fd (sharkdp.fd)
- Rust/cargo (Rustlang.Rust.MSVC)
- Node.js/npm (OpenJS.NodeJS.LTS)

### Manual Installation (if winget unavailable)

1. **Git:** https://git-scm.com/download/win
2. **Make:** Install MSYS2 from https://www.msys2.org/, then run:
   ```bash
   pacman -S make
   ```
3. **Ripgrep:** https://github.com/BurntSushi/ripgrep/releases
4. **Visual Studio Build Tools:** https://visualstudio.microsoft.com/downloads/
5. **Neovim:** https://github.com/neovim/neovim/releases

### Important Notes for Windows

- **Junction Points**: Windows uses junction points (`mklink /J`) instead of symlinks, which work without administrator privileges
- **PATH**: After installing dependencies, restart your terminal to refresh PATH
- **MSYS2**: After installing MSYS2, open MSYS2 terminal and run `pacman -S make`

---

## Windows WSL2 Installation

WSL2 runs Linux, so follow the **Linux (Ubuntu/Debian)** instructions above.

### Setup WSL2 (if not already installed)

1. **Install WSL2:**
   ```powershell
   wsl --install -d Ubuntu
   ```

2. **Restart your computer**

3. **Set up Ubuntu** and follow the Ubuntu installation steps above

### Recommended: Install Homebrew on WSL2 (Easy Neovim 0.11+ Installation)

The easiest way to get Neovim 0.11+ on WSL2 is via Homebrew:

1. **Install Homebrew:**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Add Homebrew to PATH** (follow the instructions printed after installation):
   ```bash
   echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
   ```

3. **Install Neovim:**
   ```bash
   brew install neovim
   ```

The bootstrap script will automatically detect and use Homebrew if available!

### Accessing Files

- **From Windows**: `\\wsl$\Ubuntu\home\<username>\.config\nvim_config_tool`
- **From WSL**: `~/.config/nvim_config_tool`

---

## Post-Installation

### Verify Installation

All platforms:
```bash
# Check status
./scripts/nvim-tool.sh status   # Unix/Linux/macOS
scripts\nvim-tool.bat status    # Windows

# Start Neovim
nvim
```

### First Launch

On first launch, Neovim will:
1. Install lazy.nvim plugin manager
2. Download and install all plugins
3. Install LSP servers (Mason will prompt)
4. Set up clangd for C/C++ (if available)

**Be patient** - first launch takes 1-2 minutes for plugin installation.

### Generate compile_commands.json (for C++ projects)

For optimal LSP rename and cross-file features:

**CMake:**
```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
ln -s build/compile_commands.json .
```

**Make:**
```bash
# Install bear first
# macOS: brew install bear
# Linux: sudo apt-get install bear / sudo dnf install bear
# Windows: not easily available, use CMake or compiledb

bear -- make
```

---

## Platform-Specific Configuration Locations

### Neovim Config Directory

- **macOS/Linux**: `~/.config/nvim` → symlink to `~/.config/nvim_config_tool/nvim`
- **Windows**: `%LOCALAPPDATA%\nvim` → junction to `%USERPROFILE%\.config\nvim_config_tool\nvim`
- **WSL2**: `~/.config/nvim` → symlink to `~/.config/nvim_config_tool/nvim`

### Data/Cache Directories

- **macOS**: `~/.local/share/nvim` and `~/.local/state/nvim`
- **Linux**: `~/.local/share/nvim` and `~/.local/state/nvim`
- **Windows**: `%LOCALAPPDATA%\nvim-data`
- **WSL2**: `~/.local/share/nvim` and `~/.local/state/nvim`

---

## Updating Configuration

### All Platforms

**Unix/Linux/macOS:**
```bash
cd ~/.config/nvim_config_tool
bash bootstrap.sh update
```

**Windows:**
```cmd
cd %USERPROFILE%\.config\nvim_config_tool
bootstrap.bat update
```

This will:
- Stash any local changes
- Pull latest configuration
- Update plugins
- Update dependencies if needed

---

## Troubleshooting

### macOS

**Issue**: `command not found: nvim`
```bash
brew install neovim
# OR
brew upgrade neovim
```

**Issue**: Plugins not loading
```bash
# Remove plugin directory and reinstall
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

### Linux

**Issue**: Neovim version too old (< 0.11)
```bash
# Use AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

**Issue**: Missing compiler
```bash
# Fedora
sudo dnf install gcc make

# Ubuntu/Debian
sudo apt-get install build-essential
```

### Windows

**Issue**: `mklink` permission denied
- Junction points (`mklink /J`) should work without admin rights
- If it fails, try running PowerShell/cmd as Administrator once

**Issue**: `nvim` not found after installation
- Restart your terminal to refresh PATH
- Check installation: `where nvim`
- Manually add to PATH if needed

**Issue**: Make not available
```powershell
# Install MSYS2, then in MSYS2 terminal:
pacman -S make

# Add MSYS2 to PATH:
# C:\msys64\usr\bin
```

### WSL2

**Issue**: Can't access Windows files
```bash
# Windows C: drive is mounted at:
cd /mnt/c/
```

**Issue**: Git authentication fails
```bash
# Use SSH keys or configure Git credential helper
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

---

## Uninstallation

### All Platforms

**Unix/Linux/macOS:**
```bash
cd ~/.config/nvim_config_tool
bash bootstrap.sh clean
rm -rf ~/.config/nvim_config_tool
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

**Windows:**
```cmd
cd %USERPROFILE%\.config\nvim_config_tool
bootstrap.bat clean
rmdir /s /q %USERPROFILE%\.config\nvim_config_tool
rmdir /s /q %LOCALAPPDATA%\nvim-data
```

This will:
- Remove the symlink/junction
- Optionally restore your previous backup
- Keep the repository for future use (unless you delete it)

---

## Getting Help

- **Configuration Guide**: See [CLAUDE.md](CLAUDE.md) for keybindings and features
- **Bootstrap Help**: Run `bootstrap.sh help` or `bootstrap.bat help`
- **Tool Help**: Run `scripts/nvim-tool.sh help` or `scripts\nvim-tool.bat help`
- **Neovim Help**: Press `Space+sh` in Neovim to search help
