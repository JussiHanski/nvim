#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NVIM_SOURCE_DIR=""

# Resolve the Neovim source directory based on repository layout
if [ -f "$REPO_DIR/init.lua" ]; then
    NVIM_SOURCE_DIR="$REPO_DIR"
elif [ -f "$REPO_DIR/nvim/init.lua" ]; then
    NVIM_SOURCE_DIR="$REPO_DIR/nvim"
else
    echo "Error: Neovim config not found. Expected init.lua at $REPO_DIR or $REPO_DIR/nvim" >&2
    exit 1
fi

# Determine Neovim config directory based on OS
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    NVIM_CONFIG_DIR="$HOME/AppData/Local/nvim"
else
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
fi

# Helper functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}→ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

check_dependencies() {
    local auto_install_optional="${1:-false}"

    print_info "Checking dependencies..."

    local missing_critical=()
    local missing_optional=()

    # Critical dependencies
    for dep in git make unzip node; do
        if ! command -v "$dep" &> /dev/null; then
            missing_critical+=("$dep")
        else
            if [ "$dep" = "node" ]; then
                print_success "node found ($(node --version))"
            else
                print_success "$dep found"
            fi
        fi
    done

    # Check for C compiler (gcc or clang)
    if ! command -v gcc &> /dev/null && ! command -v clang &> /dev/null; then
        missing_critical+=("gcc or clang")
    else
        if command -v gcc &> /dev/null; then
            print_success "gcc found ($(gcc --version | head -n1 | cut -d' ' -f3-))"
        else
            print_success "clang found ($(clang --version | head -n1 | cut -d' ' -f4))"
        fi
    fi

    # Check ripgrep
    if ! command -v rg &> /dev/null; then
        missing_critical+=("ripgrep")
    else
        print_success "ripgrep found"
    fi

    # Optional dependencies
    for dep in fd cargo npm; do
        # Special handling for fd (called fdfind on Ubuntu/Debian)
        if [ "$dep" = "fd" ]; then
            if command -v fd &> /dev/null || command -v fdfind &> /dev/null; then
                print_success "fd found"
            else
                missing_optional+=("$dep")
            fi
        else
            if ! command -v "$dep" &> /dev/null; then
                missing_optional+=("$dep")
            else
                print_success "$dep found"
            fi
        fi
    done

    # Report critical dependencies
    if [ ${#missing_critical[@]} -ne 0 ]; then
        print_error "Missing critical dependencies: ${missing_critical[*]}"

        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                read -p "Would you like to install them using Homebrew? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installing dependencies with Homebrew..."
                    if brew install ${missing_critical[*]}; then
                        print_success "Dependencies installed successfully!"
                        return 0
                    else
                        print_error "Some dependencies failed to install"
                        exit 1
                    fi
                fi
            fi
            print_info "Install them with:"
            print_info "  brew install ${missing_critical[*]}"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Map generic names to package manager specific names
            local apt_packages=()
            local dnf_packages=()

            for dep in "${missing_critical[@]}"; do
                case "$dep" in
                    "gcc or clang")
                        apt_packages+=("build-essential")
                        dnf_packages+=("gcc" "make")
                        ;;
                    node)
                        apt_packages+=("nodejs")
                        dnf_packages+=("nodejs")
                        ;;
                    *)
                        apt_packages+=("$dep")
                        dnf_packages+=("$dep")
                        ;;
                esac
            done

            if command -v apt-get &> /dev/null; then
                read -p "Would you like to install them using apt-get? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installing dependencies with apt-get..."
                    if sudo apt-get update && sudo apt-get install -y ${apt_packages[*]}; then
                        print_success "Dependencies installed successfully!"
                        return 0
                    else
                        print_error "Some dependencies failed to install"
                        exit 1
                    fi
                fi
                print_info "Install them with:"
                print_info "  sudo apt-get update && sudo apt-get install -y ${apt_packages[*]}"
            elif command -v dnf &> /dev/null; then
                read -p "Would you like to install them using dnf? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installing dependencies with dnf..."
                    if sudo dnf install -y ${dnf_packages[*]}; then
                        print_success "Dependencies installed successfully!"
                        return 0
                    else
                        print_error "Some dependencies failed to install"
                        exit 1
                    fi
                fi
                print_info "Install them with:"
                print_info "  sudo dnf install -y ${dnf_packages[*]}"
            else
                print_info "Install them manually"
            fi
        fi
        exit 1
    fi

    # Report optional dependencies
    if [ ${#missing_optional[@]} -ne 0 ]; then
        print_warning "Missing optional dependencies: ${missing_optional[*]}"
        print_info "These are optional but recommended for better performance"

        # Check for Homebrew first (works on macOS and Linux)
        if command -v brew &> /dev/null; then
            # Map dependency names to brew package names
            local brew_packages=()
            for dep in "${missing_optional[@]}"; do
                case "$dep" in
                    cargo) brew_packages+=("rust") ;;
                    *) brew_packages+=("$dep") ;;
                esac
            done

            # Auto-install if requested (during init), otherwise ask
            if [ "$auto_install_optional" = "true" ]; then
                print_info "Installing optional dependencies with Homebrew..."
                brew install ${brew_packages[*]}
                print_success "Optional dependencies installation complete!"
            else
                read -p "Would you like to install them using Homebrew? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installing optional dependencies with Homebrew..."
                    brew install ${brew_packages[*]}
                    print_success "Optional dependencies installation complete!"
                else
                    print_info "You can install them later with:"
                    print_info "  brew install ${brew_packages[*]}"
                fi
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Map dependency names to package manager specific names
            local apt_packages=()
            local dnf_packages=()

            for dep in "${missing_optional[@]}"; do
                case "$dep" in
                    fd)
                        apt_packages+=("fd-find")  # Ubuntu package name
                        dnf_packages+=("fd-find")   # Fedora package name
                        ;;
                    cargo)
                        apt_packages+=("cargo")
                        dnf_packages+=("cargo")
                        ;;
                    node)
                        apt_packages+=("nodejs")    # Ubuntu package name
                        dnf_packages+=("nodejs")    # Fedora package name
                        ;;
                    npm)
                        apt_packages+=("npm")
                        dnf_packages+=("npm")
                        ;;
                    *)
                        apt_packages+=("$dep")
                        dnf_packages+=("$dep")
                        ;;
                esac
            done

            if command -v apt-get &> /dev/null; then
                # Auto-install if requested (during init), otherwise ask
                if [ "$auto_install_optional" = "true" ]; then
                    print_info "Installing optional dependencies with apt-get..."
                    if sudo apt-get install -y ${apt_packages[*]} 2>&1; then
                        print_success "Optional dependencies installation complete!"
                    else
                        print_warning "apt-get encountered errors (may be due to unrelated package issues)"
                        print_info "If you see dpkg errors unrelated to these packages, fix them first:"
                        print_info "  sudo dpkg --configure -a"
                        print_info "Then try installing optional dependencies manually:"
                        print_info "  sudo apt-get install -y ${apt_packages[*]}"
                    fi
                else
                    read -p "Would you like to install them using apt-get? (y/n): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        print_info "Installing optional dependencies with apt-get..."
                        if sudo apt-get install -y ${apt_packages[*]} 2>&1; then
                            print_success "Optional dependencies installation complete!"
                        else
                            print_warning "apt-get encountered errors (may be due to unrelated package issues)"
                            print_info "If you see dpkg errors unrelated to these packages, fix them first:"
                            print_info "  sudo dpkg --configure -a"
                            print_info "Then try installing optional dependencies manually:"
                            print_info "  sudo apt-get install -y ${apt_packages[*]}"
                        fi
                    else
                        print_info "You can install them later with:"
                        print_info "  sudo apt-get install -y ${apt_packages[*]}"
                    fi
                fi
            elif command -v dnf &> /dev/null; then
                # Auto-install if requested (during init), otherwise ask
                if [ "$auto_install_optional" = "true" ]; then
                    print_info "Installing optional dependencies with dnf..."
                    sudo dnf install -y ${dnf_packages[*]}
                    print_success "Optional dependencies installation complete!"
                else
                    read -p "Would you like to install them using dnf? (y/n): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        print_info "Installing optional dependencies with dnf..."
                        sudo dnf install -y ${dnf_packages[*]}
                        print_success "Optional dependencies installation complete!"
                    else
                        print_info "You can install them later with:"
                        print_info "  sudo dnf install -y ${dnf_packages[*]}"
                    fi
                fi
            else
                print_info "No supported package manager found. You can install optional dependencies manually."
            fi
        else
            print_info "Install optional dependencies manually for your platform."
        fi
    fi

    print_success "All critical dependencies found"
    echo
}

check_nvim_version() {
    local version_output=$(nvim --version | head -n 1)
    local version=$(echo "$version_output" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sed 's/v//')
    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)

    # Require Neovim 0.11 or higher (for nvim-lspconfig compatibility)
    local required_major=0
    local required_minor=11

    if [ "$major" -lt "$required_major" ] || ([ "$major" -eq "$required_major" ] && [ "$minor" -lt "$required_minor" ]); then
        return 1
    fi
    return 0
}

check_nvim_installed() {
    if ! command -v nvim &> /dev/null; then
        print_warning "Neovim is not installed."
        read -p "Would you like to install Neovim? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_neovim
        else
            print_info "Skipping Neovim installation. You can install it manually later."
            return
        fi
    else
        local version_output=$(nvim --version | head -n 1)
        local nvim_path=$(command -v nvim)

        if check_nvim_version; then
            print_success "Neovim is installed ($version_output)"
            print_info "Location: $nvim_path"
        else
            print_warning "Neovim version is outdated ($version_output)"
            print_info "Location: $nvim_path"
            print_info "Neovim 0.11+ is required for nvim-lspconfig compatibility"

            # Check if there's a system nvim that might conflict with brew
            if command -v brew &> /dev/null && ! brew list neovim &> /dev/null; then
                if [[ "$nvim_path" == "/usr/bin/nvim" ]] || [[ "$nvim_path" == "/bin/nvim" ]]; then
                    print_warning "Neovim appears to be from system package manager (not Homebrew)"
                    print_info "Recommendation: Uninstall system nvim and install via Homebrew for latest version"
                    read -p "Remove system Neovim and install via Homebrew? (y/n): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        # Try to remove system nvim
                        if command -v apt-get &> /dev/null; then
                            sudo apt-get remove -y neovim
                        elif command -v dnf &> /dev/null; then
                            sudo dnf remove -y neovim
                        elif command -v pacman &> /dev/null; then
                            sudo pacman -R --noconfirm neovim
                        fi
                        # Install via brew
                        install_neovim
                        return
                    fi
                fi
            fi

            read -p "Would you like to upgrade Neovim? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                upgrade_neovim
            else
                print_warning "Continuing with outdated Neovim version. You may encounter errors."
            fi
        fi
    fi
}

install_neovim() {
    print_info "Installing Neovim 0.11+..."

    # Check for Homebrew first (works on macOS and Linux/WSL)
    if command -v brew &> /dev/null; then
        print_info "Homebrew detected, installing Neovim..."
        brew install neovim
        print_success "Neovim installed via Homebrew: $(nvim --version | head -n 1)"
        return 0
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_error "Homebrew not found. Please install Neovim manually."
        return 1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            print_warning "Ubuntu/Debian default repos may have old Neovim (0.10.x)"
            echo "Options:"
            echo "  1) Build from source (recommended for WSL/Ubuntu, latest stable)"
            echo "  2) Install via AppImage (latest version, self-contained)"
            echo "  3) Install from default repo (may be old)"
            read -p "Choose option (1-3): " -n 1 -r
            echo

            case $REPLY in
                1)
                    install_neovim_from_source
                    return $?
                    ;;
                2)
                    install_neovim_appimage
                    return $?
                    ;;
                3)
                    sudo apt-get update && sudo apt-get install -y neovim
                    ;;
                *)
                    print_error "Invalid option"
                    return 1
                    ;;
            esac
        elif command -v dnf &> /dev/null; then
            # Fedora 40+ has recent Neovim
            sudo dnf install -y neovim
        elif command -v pacman &> /dev/null; then
            # Arch always has latest
            sudo pacman -S --noconfirm neovim
        else
            print_warning "No supported package manager found."
            print_info "Installing via AppImage..."
            install_neovim_appimage
            return $?
        fi
    else
        print_error "Unsupported OS. Please install Neovim manually."
        return 1
    fi

    # Verify installation
    if check_nvim_version; then
        print_success "Neovim installed successfully: $(nvim --version | head -n 1)"
    else
        print_warning "Neovim installed but version is < 0.11"
        print_info "You can upgrade with: ./scripts/nvim-tool.sh update"
    fi
}

upgrade_neovim() {
    print_info "Upgrading Neovim to 0.11+..."

    # Check for Homebrew first (works on macOS and Linux/WSL)
    if command -v brew &> /dev/null; then
        # Check if neovim is installed via brew
        if brew list neovim &> /dev/null; then
            print_info "Homebrew detected, upgrading Neovim..."
            brew upgrade neovim
            print_success "Neovim upgraded via Homebrew: $(nvim --version | head -n 1)"
            return 0
        else
            # Homebrew exists but neovim not installed via brew
            # This means nvim is from another source (apt, old install, etc.)
            print_info "Homebrew detected, but Neovim not installed via brew"
            print_info "Installing Neovim via Homebrew..."
            brew install neovim
            print_success "Neovim installed via Homebrew: $(nvim --version | head -n 1)"
            return 0
        fi
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_error "Homebrew not found. Please upgrade Neovim manually."
        return 1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian, default repos often have old versions
        # Offer AppImage as the most reliable option
        if command -v apt-get &> /dev/null; then
            print_warning "Ubuntu/Debian default repos may not have Neovim 0.11+"
            echo "Options:"
            echo "  1) Build from source (recommended for WSL/Ubuntu, latest stable)"
            echo "  2) Install via AppImage (latest version, self-contained)"
            echo "  3) Try unstable PPA (may have newer version)"
            echo "  4) Try apt upgrade (likely still old)"
            read -p "Choose option (1-4): " -n 1 -r
            echo

            case $REPLY in
                1)
                    install_neovim_from_source
                    return $?
                    ;;
                2)
                    install_neovim_appimage
                    return $?
                    ;;
                3)
                    print_info "Adding Neovim unstable PPA..."
                    sudo add-apt-repository -y ppa:neovim-ppa/unstable
                    sudo apt-get update
                    sudo apt-get install -y neovim
                    ;;
                4)
                    sudo apt-get update && sudo apt-get install -y --only-upgrade neovim
                    ;;
                *)
                    print_error "Invalid option"
                    return 1
                    ;;
            esac
        elif command -v dnf &> /dev/null; then
            # Fedora 40+ should have recent Neovim
            sudo dnf upgrade -y neovim
        elif command -v pacman &> /dev/null; then
            # Arch always has latest
            sudo pacman -Syu --noconfirm neovim
        else
            print_error "No supported package manager found."
            print_info "Installing via AppImage..."
            install_neovim_appimage
            return $?
        fi
    else
        print_error "Unsupported OS. Please upgrade Neovim manually."
        return 1
    fi

    # Verify upgrade worked
    if check_nvim_version; then
        print_success "Neovim upgraded successfully ($(nvim --version | head -n 1))"
    else
        print_warning "Upgrade completed but version is still < 0.11"
        print_info "Consider installing Homebrew or using AppImage"
    fi
}

install_neovim_from_source() {
    print_info "Building Neovim from source..."

    local build_deps_installed=false
    local nvim_repo="/tmp/neovim_build_$$"

    # Install build dependencies
    print_info "Installing build dependencies..."
    if command -v apt-get &> /dev/null; then
        if sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential; then
            build_deps_installed=true
        fi
    elif command -v dnf &> /dev/null; then
        if sudo dnf install -y ninja-build cmake gcc make unzip gettext curl; then
            build_deps_installed=true
        fi
    else
        print_error "Unsupported package manager for automatic dependency installation"
        return 1
    fi

    if [ "$build_deps_installed" = false ]; then
        print_error "Failed to install build dependencies"
        return 1
    fi

    # Clone Neovim repository
    print_info "Cloning Neovim repository..."
    if ! git clone https://github.com/neovim/neovim.git "$nvim_repo"; then
        print_error "Failed to clone Neovim repository"
        return 1
    fi

    cd "$nvim_repo"

    # Get latest stable tag
    print_info "Finding latest stable release..."
    local latest_tag=$(git tag -l 'v[0-9]*.[0-9]*.[0-9]*' | grep -v 'rc' | sort -V | tail -n1)

    if [ -z "$latest_tag" ]; then
        print_error "Could not determine latest stable version"
        cd -
        rm -rf "$nvim_repo"
        return 1
    fi

    print_info "Checking out stable version $latest_tag..."
    if ! git checkout "$latest_tag"; then
        print_error "Failed to checkout $latest_tag"
        cd -
        rm -rf "$nvim_repo"
        return 1
    fi

    # Build
    print_info "Building Neovim (this may take a few minutes)..."
    if ! make CMAKE_BUILD_TYPE=Release; then
        print_error "Build failed"
        cd -
        rm -rf "$nvim_repo"
        return 1
    fi

    # Install
    print_info "Installing Neovim..."
    if ! sudo make install; then
        print_error "Installation failed"
        cd -
        rm -rf "$nvim_repo"
        return 1
    fi

    # Cleanup
    cd -
    rm -rf "$nvim_repo"

    print_success "Neovim built and installed from source: $(nvim --version | head -n 1)"
    return 0
}

install_neovim_appimage() {
    print_info "Installing Neovim AppImage..."

    local temp_file="/tmp/nvim.appimage"
    local install_dir="/usr/local/bin"

    # Download latest AppImage
    print_info "Downloading latest Neovim AppImage..."
    if command -v curl &> /dev/null; then
        curl -L -o "$temp_file" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    elif command -v wget &> /dev/null; then
        wget -O "$temp_file" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    else
        print_error "Neither curl nor wget found. Cannot download AppImage."
        return 1
    fi

    # Make executable
    chmod +x "$temp_file"

    # Test if it works
    if ! "$temp_file" --version &> /dev/null; then
        print_error "AppImage failed to run. Your system may not support AppImages."
        print_info "Try: sudo apt-get install fuse libfuse2"
        rm -f "$temp_file"
        return 1
    fi

    # Remove old nvim if it exists
    if [ -f "$install_dir/nvim" ]; then
        print_info "Removing old nvim from $install_dir/nvim"
        sudo rm -f "$install_dir/nvim"
    fi

    # Install
    print_info "Installing to $install_dir/nvim"
    sudo mv "$temp_file" "$install_dir/nvim"

    print_success "Neovim AppImage installed: $(nvim --version | head -n 1)"
    return 0
}

backup_existing_config() {
    if [ -e "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_dir="$NVIM_CONFIG_DIR.backup.$timestamp"

        print_info "Backing up existing config to $backup_dir"
        mv "$NVIM_CONFIG_DIR" "$backup_dir"
        print_success "Backup created at $backup_dir"

        echo "$backup_dir" > "$REPO_DIR/.last_backup"
    elif [ -L "$NVIM_CONFIG_DIR" ]; then
        local link_target=$(readlink "$NVIM_CONFIG_DIR")
        if [ "$link_target" = "$NVIM_SOURCE_DIR" ]; then
            print_info "Neovim config already points to this repository"
            return 0
        else
            print_warning "Neovim config is a symlink to: $link_target"
            read -p "Remove this symlink and create a new one? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$NVIM_CONFIG_DIR"
            else
                print_error "Cannot proceed without removing existing symlink"
                exit 1
            fi
        fi
    fi
}

create_symlink() {
    local resolved_source
    local resolved_target
    local resolved_config

    if command -v realpath &> /dev/null; then
        resolved_source=$(realpath "$NVIM_SOURCE_DIR")
        resolved_target=$(realpath "$(dirname "$NVIM_CONFIG_DIR")")
        resolved_config=$(realpath "$NVIM_CONFIG_DIR" 2>/dev/null || true)
    else
        resolved_source=$(readlink -f "$NVIM_SOURCE_DIR")
        resolved_target=$(readlink -f "$(dirname "$NVIM_CONFIG_DIR")")
        resolved_config=$(readlink -f "$NVIM_CONFIG_DIR" 2>/dev/null || true)
    fi

    if [[ -n "$resolved_config" && "$resolved_source" == "$resolved_config"* ]]; then
        print_error "Refusing to create a nested config: $NVIM_SOURCE_DIR is inside $NVIM_CONFIG_DIR"
        exit 1
    fi

    if [[ "$resolved_source" == "$resolved_target"* ]]; then
        print_error "Refusing to create a nested config: $NVIM_SOURCE_DIR is inside $(dirname "$NVIM_CONFIG_DIR")"
        exit 1
    fi

    print_info "Creating symlink: $NVIM_CONFIG_DIR -> $NVIM_SOURCE_DIR"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"

    ln -s "$NVIM_SOURCE_DIR" "$NVIM_CONFIG_DIR"
    print_success "Symlink created successfully"
}

install_plugins() {
    print_info "Installing plugins..."

    if [ ! -f "$NVIM_SOURCE_DIR/init.lua" ]; then
        print_warning "No init.lua found, skipping plugin installation"
        return 0
    fi

    # Run Neovim headless to trigger lazy.nvim installation and plugin sync
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

    print_success "Plugins installed"
}

cmd_init() {
    print_info "Initializing Neovim configuration..."

    # Auto-install optional dependencies during init
    check_dependencies true
    check_nvim_installed

    # Check if nvim source directory exists
    if [ ! -d "$NVIM_SOURCE_DIR" ]; then
        print_error "Neovim configuration directory not found at $NVIM_SOURCE_DIR"
        print_info "Please ensure the repository is properly set up"
        exit 1
    fi

    backup_existing_config

    if [ -L "$NVIM_CONFIG_DIR" ] && [ "$(readlink "$NVIM_CONFIG_DIR")" = "$NVIM_SOURCE_DIR" ]; then
        print_info "Neovim config already points to this repository"
    else
        create_symlink
    fi

    install_plugins

    print_success "Initialization complete!"
    print_info "You can now start Neovim with: nvim"
}

cmd_update() {
    print_info "Updating Neovim configuration..."

    # Check if already initialized
    if [ ! -L "$NVIM_CONFIG_DIR" ]; then
        print_error "Configuration not initialized. Run: init"
        exit 1
    fi

    # Stash any local changes and pull FIRST (before any other checks)
    cd "$REPO_DIR"

    if ! git diff-index --quiet HEAD --; then
        print_warning "You have uncommitted changes"
        git status --short
        read -p "Stash changes and continue? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git stash push -m "Auto-stash before update $(date +%Y%m%d_%H%M%S)"
            print_success "Changes stashed"
        else
            print_error "Update cancelled"
            exit 1
        fi
    fi

    # Pull latest changes FIRST
    print_info "Pulling latest changes..."
    local before_hash=$(git rev-parse HEAD)
    git pull origin main
    local after_hash=$(git rev-parse HEAD)

    # If script was updated, re-execute with the new version
    if [ "$before_hash" != "$after_hash" ] && [ -z "$NVIM_TOOL_REEXEC" ]; then
        print_info "Scripts updated, re-running with latest version..."
        export NVIM_TOOL_REEXEC=1
        exec bash "$SCRIPT_DIR/nvim-tool.sh" update
    fi

    # Now run checks with the latest script version
    check_dependencies
    check_nvim_installed

    # Update plugins
    print_info "Updating plugins..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

    print_success "Update complete!"

    # Show what changed
    print_info "Recent changes:"
    git log --oneline -5
}

cmd_clean() {
    print_warning "This will remove the Neovim configuration symlink"
    read -p "Continue? (y/n): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Clean cancelled"
        exit 0
    fi

    # Remove symlink
    if [ -L "$NVIM_CONFIG_DIR" ]; then
        rm "$NVIM_CONFIG_DIR"
        print_success "Symlink removed"
    else
        print_info "No symlink found at $NVIM_CONFIG_DIR"
    fi

    # Optionally restore backup
    if [ -f "$REPO_DIR/.last_backup" ]; then
        local last_backup=$(cat "$REPO_DIR/.last_backup")
        if [ -d "$last_backup" ]; then
            read -p "Restore backup from $last_backup? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$last_backup" "$NVIM_CONFIG_DIR"
                print_success "Backup restored"
                rm "$REPO_DIR/.last_backup"
            fi
        fi
    fi

    print_success "Clean complete"
}

cmd_status() {
    print_info "Neovim Configuration Tool Status"
    echo

    # Check symlink
    if [ -L "$NVIM_CONFIG_DIR" ]; then
        local target=$(readlink "$NVIM_CONFIG_DIR")
        print_success "Symlink: $NVIM_CONFIG_DIR -> $target"

        if [ "$target" = "$NVIM_SOURCE_DIR" ]; then
            print_success "Symlink points to this repository"
        else
            print_warning "Symlink points to a different location"
        fi
    else
        print_warning "No symlink found at $NVIM_CONFIG_DIR"
    fi

    echo

    # Check Neovim installation and version
    if command -v nvim &> /dev/null; then
        local version_output=$(nvim --version | head -n 1)
        if check_nvim_version; then
            print_success "Neovim: $version_output"
        else
            print_warning "Neovim: $version_output (0.11+ recommended)"
        fi
    else
        print_warning "Neovim: Not installed"
    fi

    echo

    # Check dependencies
    print_info "Dependencies:"
    check_dependencies

    # Git status
    cd "$REPO_DIR"
    print_info "Git Status:"
    git status --short

    echo
    print_info "Recent commits:"
    git log --oneline -5
}

show_help() {
    cat << EOF
Neovim Configuration Tool

Usage: $0 <command>

Commands:
    init                Initialize Neovim configuration (first-time setup)
    update              Update to latest configuration
    clean               Remove configuration and restore backup
    status              Show configuration status
    help                Show this help message

Examples:
    $0 init
    $0 update
    $0 status
    $0 clean

Configuration:
    Repository:  $REPO_DIR
    Config Dir:  $NVIM_CONFIG_DIR
    Source Dir:  $NVIM_SOURCE_DIR

EOF
}

main() {
    local command="${1:-help}"
    shift || true

    case "$command" in
        init)
            cmd_init
            ;;
        update)
            cmd_update
            ;;
        clean)
            cmd_clean
            ;;
        status)
            cmd_status
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
