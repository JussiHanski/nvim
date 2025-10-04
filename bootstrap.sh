#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="git@github-personal:JussiHanski/nvim.git"
INSTALL_DIR="$HOME/.config/nvim_config_tool"
TOOL_SCRIPT="$INSTALL_DIR/scripts/nvim-tool.sh"

# Helper functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${YELLOW}$1${NC}"
}

check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git first."
        exit 1
    fi
}

clone_repo() {
    if [ -d "$INSTALL_DIR" ]; then
        print_info "Repository already exists at $INSTALL_DIR"
        return 0
    fi

    print_info "Cloning repository to $INSTALL_DIR..."

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$INSTALL_DIR")"

    if git clone "$REPO_URL" "$INSTALL_DIR"; then
        print_success "Repository cloned successfully"
    else
        print_error "Failed to clone repository"
        exit 1
    fi
}

show_help() {
    cat << EOF
Neovim Configuration Tool - Bootstrap Script

Usage: $0 <command>

Commands:
    init        Initialize Neovim configuration (first-time setup)
    update      Update to latest configuration
    clean       Remove configuration and restore backup
    status      Show configuration status
    help        Show this help message

After initial setup, you can use the tool directly:
    $TOOL_SCRIPT <command>

EOF
}

main() {
    local command="${1:-help}"

    case "$command" in
        init|update|clean|status)
            check_git

            # Clone repo if needed (for init command)
            if [ "$command" = "init" ]; then
                clone_repo
            fi

            # Check if tool script exists
            if [ ! -f "$TOOL_SCRIPT" ]; then
                if [ "$command" = "init" ]; then
                    print_error "Tool script not found at $TOOL_SCRIPT after cloning"
                    exit 1
                else
                    print_error "Repository not initialized. Run: $0 init"
                    exit 1
                fi
            fi

            # Delegate to the main tool
            bash "$TOOL_SCRIPT" "$@"
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
