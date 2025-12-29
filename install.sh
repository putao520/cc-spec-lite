#!/bin/bash

#############################################################################
# cc-spec-lite Installation Script
#############################################################################
# SPEC-driven development framework for Claude Code
#
# Features:
# - Multi-language support (English/Chinese)
# - Automatic aiw installation
# - Update management
# - Backup existing configuration
#############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/putao520/cc-spec-lite"
VERSION="1.0.0"
INSTALL_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude/backup/cc-spec-lite-$(date +%Y%m%d-%H%M%S)"
AIW_MIN_VERSION="0.5.30"

#############################################################################
# Helper Functions
#############################################################################

print_header() {
    echo -e "${BLUE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  cc-spec-lite Installer v${VERSION}"
    echo "  SPEC-driven development framework for Claude Code"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

#############################################################################
# Language Selection
#############################################################################

select_language() {
    echo ""
    print_info "Select language / 选择语言:"
    echo "  1) English (default)"
    echo "  2) 简体中文"
    echo ""
    read -p "Enter choice [1-2] (default: 1): " lang_choice

    case $lang_choice in
        2)
            LANG="zh"
            print_info "已选择中文"
            ;;
        *)
            LANG="en"
            print_info "Selected English"
            ;;
    esac
}

#############################################################################
# AIW Installation Check
#############################################################################

check_aiw() {
    print_info "Checking AI Warden CLI (aiw)..."

    if command -v aiw &> /dev/null; then
        AIW_VERSION=$(aiw --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "0.0.0")
        print_success "aiw found: v${AIW_VERSION}"

        # Check version
        if [[ "$(printf '%s\n' "$AIW_MIN_VERSION" "$AIW_VERSION" | sort -V | head -n1)" != "$AIW_MIN_VERSION" ]]; then
            print_warning "aiw version ${AIW_VERSION} is below minimum ${AIW_MIN_VERSION}"
            read -p "Update aiw? [Y/n]: " update_aiw
            if [[ "$update_aiw" != "n" && "$update_aiw" != "N" ]]; then
                install_aiw
            fi
        fi
    else
        print_warning "aiw not found"
        read -p "Install AI Warden CLI (aiw)? [Y/n]: " install_aiw_choice
        if [[ "$install_aiw_choice" != "n" && "$install_aiw_choice" != "N" ]]; then
            install_aiw
        else
            print_error "aiw is required for cc-spec-lite to work properly"
            exit 1
        fi
    fi
}

install_aiw() {
    print_info "Installing AI Warden CLI..."

    if command -v npm &> /dev/null; then
        npm install -g @putao520/agentic-warden
        print_success "aiw installed successfully"
    else
        print_error "npm not found. Please install Node.js first:"
        echo "  https://nodejs.org/"
        exit 1
    fi
}

#############################################################################
# Backup Existing Configuration
#############################################################################

backup_existing() {
    if [[ -d "$INSTALL_DIR" ]]; then
        print_info "Backing up existing configuration..."

        # Create backup directory
        mkdir -p "$BACKUP_DIR"

        # Backup existing files
        if [[ -f "$INSTALL_DIR/CLAUDE.md" ]]; then
            cp "$INSTALL_DIR/CLAUDE.md" "$BACKUP_DIR/"
        fi

        if [[ -d "$INSTALL_DIR/skills" ]]; then
            cp -r "$INSTALL_DIR/skills" "$BACKUP_DIR/" 2>/dev/null || true
        fi

        if [[ -d "$INSTALL_DIR/commands" ]]; then
            cp -r "$INSTALL_DIR/commands" "$BACKUP_DIR/" 2>/dev/null || true
        fi

        print_success "Backup created: $BACKUP_DIR"
    fi
}

#############################################################################
# Install Files
#############################################################################

install_files() {
    print_info "Installing cc-spec-lite files..."

    # Create target directories
    mkdir -p "$INSTALL_DIR/skills"
    mkdir -p "$INSTALL_DIR/commands"

    # Copy files based on language
    if [[ "$LANG" == "zh" ]]; then
        # Chinese version
        print_info "Installing Chinese version..."

        # Copy skills
        if [[ -d "skills-zh" ]]; then
            cp -r skills-zh/* "$INSTALL_DIR/skills/"
        else
            print_warning "Chinese skills not found, using English"
            cp -r skills/* "$INSTALL_DIR/skills/"
        fi

        # Copy commands
        if [[ -d "commands-zh" ]]; then
            cp -r commands-zh/* "$INSTALL_DIR/commands/"
        else
            print_warning "Chinese commands not found, using English"
            cp -r commands/* "$INSTALL_DIR/commands/"
        fi

        # Copy CLAUDE.md (Chinese)
        if [[ -f "CLAUDE-zh.md" ]]; then
            cp CLAUDE-zh.md "$INSTALL_DIR/CLAUDE.md"
        else
            cp CLAUDE.md "$INSTALL_DIR/CLAUDE.md"
        fi
    else
        # English version (default)
        print_info "Installing English version..."

        # Copy skills
        cp -r skills/* "$INSTALL_DIR/skills/"

        # Copy commands
        cp -r commands/* "$INSTALL_DIR/commands/"

        # Copy CLAUDE.md
        cp CLAUDE.md "$INSTALL_DIR/CLAUDE.md"
    fi

    # Copy scripts (always install)
    if [[ -d "scripts" ]]; then
        mkdir -p "$INSTALL_DIR/scripts"
        cp -r scripts/* "$INSTALL_DIR/scripts/"

        # Set execute permissions
        find "$INSTALL_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
    fi

    # Copy roles (if exists)
    if [[ -d "roles" ]]; then
        cp -r roles "$INSTALL_DIR/"
    fi

    print_success "Files installed successfully"
}

#############################################################################
# Update Management
#############################################################################

update_mode() {
    print_info "Update mode: checking for updates..."

    # Get latest version from GitHub
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/putao520/cc-spec-lite/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$LATEST_VERSION" ]]; then
        print_warning "Unable to check for updates"
    else
        print_info "Current version: ${VERSION}"
        print_info "Latest version: ${LATEST_VERSION}"

        if [[ "$VERSION" != "$LATEST_VERSION" ]]; then
            print_info "Update available!"
        fi
    fi

    backup_existing
    install_files

    print_success "Update completed!"
}

#############################################################################
# Verify Installation
#############################################################################

verify_installation() {
    print_info "Verifying installation..."

    # Check CLAUDE.md
    if [[ -f "$INSTALL_DIR/CLAUDE.md" ]]; then
        print_success "CLAUDE.md installed"
    else
        print_error "CLAUDE.md not found"
        return 1
    fi

    # Check skills
    if [[ -d "$INSTALL_DIR/skills" ]] && [[ -n "$(ls -A $INSTALL_DIR/skills)" ]]; then
        SKILL_COUNT=$(find "$INSTALL_DIR/skills" -name "SKILL.md" | wc -l)
        print_success "Skills installed: ${SKILL_COUNT} skills"
    else
        print_error "No skills found"
        return 1
    fi

    # Check commands
    if [[ -d "$INSTALL_DIR/commands" ]] && [[ -n "$(ls -A $INSTALL_DIR/commands)" ]]; then
        CMD_COUNT=$(find "$INSTALL_DIR/commands" -name "*.md" | wc -l)
        print_success "Commands installed: ${CMD_COUNT} commands"
    else
        print_warning "No commands found"
    fi

    # Check aiw
    if command -v aiw &> /dev/null; then
        print_success "aiw is available"
    else
        print_warning "aiw not found - some features may not work"
    fi
}

#############################################################################
# Print Usage
#############################################################################

print_usage() {
    cat << EOF

Usage: $0 [OPTIONS]

Options:
    --lang LANGUAGE    Set language (en/zh)
    --update           Update existing installation
    --backup-only      Only backup existing configuration
    --help             Show this help message

Examples:
    $0                 # Interactive installation
    $0 --lang zh       # Install Chinese version
    $0 --update        # Update existing installation

EOF
}

#############################################################################
# Main Installation Flow
#############################################################################

main() {
    print_header

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang)
                LANG="$2"
                shift 2
                ;;
            --update)
                UPDATE_MODE=true
                shift
                ;;
            --backup-only)
                backup_existing
                exit 0
                ;;
            --help)
                print_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    # Check if running from cloned repo
    if [[ ! -f "install.sh" ]]; then
        print_error "Please run this script from the cc-spec-lite directory"
        echo ""
        echo "Clone the repository first:"
        echo "  git clone ${REPO_URL}.git"
        echo "  cd cc-spec-lite"
        echo "  ./install.sh"
        exit 1
    fi

    # Update mode
    if [[ "$UPDATE_MODE" == true ]]; then
        update_mode
        verify_installation
        exit 0
    fi

    # Interactive installation
    if [[ -z "$LANG" ]]; then
        select_language
    fi

    # Check and install aiw
    check_aiw

    # Backup existing configuration
    backup_existing

    # Install files
    install_files

    # Verify installation
    verify_installation

    # Print completion message
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Installation completed successfully!                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart Claude Code"
    echo "  2. Use /spec-init to initialize your project"
    echo ""
    print_info "Documentation: ${REPO_URL}"
    print_info "Backup location: ${BACKUP_DIR}"
    echo ""
}

# Run main function
main "$@"
