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
NVIM_SOURCE_DIR="$REPO_DIR/nvim"

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
    print_info "Checking dependencies..."

    local missing_critical=()
    local missing_optional=()

    # Critical dependencies
    for dep in git make unzip; do
        if ! command -v "$dep" &> /dev/null; then
            missing_critical+=("$dep")
        else
            print_success "$dep found"
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
    for dep in fd cargo node npm; do
        if ! command -v "$dep" &> /dev/null; then
            missing_optional+=("$dep")
        else
            print_success "$dep found"
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
            print_info "Install them with:"
            if command -v apt-get &> /dev/null; then
                print_info "  sudo apt-get install ${missing_critical[*]}"
            elif command -v dnf &> /dev/null; then
                print_info "  sudo dnf install ${missing_critical[*]}"
            fi
        fi
        exit 1
    fi

    # Report optional dependencies
    if [ ${#missing_optional[@]} -ne 0 ]; then
        print_warning "Missing optional dependencies: ${missing_optional[*]}"
        print_info "These are optional but recommended for better performance"

        if [[ "$OSTYPE" == "darwin"* ]]; then
            # Map dependency names to brew package names
            local brew_packages=()
            for dep in "${missing_optional[@]}"; do
                case "$dep" in
                    cargo) brew_packages+=("rust") ;;
                    *) brew_packages+=("$dep") ;;
                esac
            done

            if command -v brew &> /dev/null; then
                read -p "Would you like to install them using Homebrew? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Installing optional dependencies with Homebrew..."
                    brew install ${brew_packages[*]}
                    print_success "Optional dependencies installation complete!"
                    return 0
                fi
            fi
            print_info "  brew install ${brew_packages[*]}"
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
        if check_nvim_version; then
            print_success "Neovim is installed ($version_output)"
        else
            print_warning "Neovim version is outdated ($version_output)"
            print_info "Neovim 0.11+ is required for nvim-lspconfig compatibility"
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
    print_info "Installing Neovim..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install neovim
        else
            print_error "Homebrew not found. Please install Neovim manually."
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y neovim
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y neovim
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm neovim
        else
            print_error "No supported package manager found. Please install Neovim manually."
            return 1
        fi
    else
        print_error "Unsupported OS. Please install Neovim manually."
        return 1
    fi

    print_success "Neovim installed successfully"
}

upgrade_neovim() {
    print_info "Upgrading Neovim..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew upgrade neovim
        else
            print_error "Homebrew not found. Please upgrade Neovim manually."
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y --only-upgrade neovim
        elif command -v dnf &> /dev/null; then
            sudo dnf upgrade -y neovim
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm neovim
        else
            print_error "No supported package manager found. Please upgrade Neovim manually."
            return 1
        fi
    else
        print_error "Unsupported OS. Please upgrade Neovim manually."
        return 1
    fi

    print_success "Neovim upgraded successfully ($(nvim --version | head -n 1))"
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

    check_dependencies
    check_nvim_installed

    # Check if nvim source directory exists
    if [ ! -d "$NVIM_SOURCE_DIR" ]; then
        print_error "Neovim configuration directory not found at $NVIM_SOURCE_DIR"
        print_info "Please ensure the repository is properly set up"
        exit 1
    fi

    backup_existing_config
    create_symlink
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
