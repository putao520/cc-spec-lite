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
            print_info "已选择中文 / Selected Chinese"
            ;;
        *)
            LANG="en"
            print_info "Selected English / 已选择英文"
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

        if [[ -d "$INSTALL_DIR/scripts" ]]; then
            cp -r "$INSTALL_DIR/scripts" "$BACKUP_DIR/" 2>/dev/null || true
        fi

        if [[ -d "$INSTALL_DIR/roles" ]]; then
            cp -r "$INSTALL_DIR/roles" "$BACKUP_DIR/" 2>/dev/null || true
        fi

        print_success "Backup created: $BACKUP_DIR"
    fi
}

#############################################################################
# Install Files
#############################################################################

install_files() {
    print_info "Installing cc-spec-lite files..."

    # Language directory
    LANG_DIR="${LANG}"

    # Check if language directory exists
    if [[ ! -d "$LANG_DIR" ]]; then
        print_error "Language directory not found: $LANG_DIR"
        exit 1
    fi

    print_info "Installing from: ${LANG_DIR}/"

    # Copy CLAUDE.md
    if [[ -f "$LANG_DIR/CLAUDE.md" ]]; then
        cp "$LANG_DIR/CLAUDE.md" "$INSTALL_DIR/CLAUDE.md"
        print_success "Installed CLAUDE.md"
    else
        print_error "CLAUDE.md not found in ${LANG_DIR}/"
        exit 1
    fi

    # Copy skills
    if [[ -d "$LANG_DIR/skills" ]]; then
        mkdir -p "$INSTALL_DIR/skills"
        cp -r "$LANG_DIR/skills/"* "$INSTALL_DIR/skills/"
        print_success "Installed skills"
    else
        print_warning "No skills directory found"
    fi

    # Copy commands
    if [[ -d "$LANG_DIR/commands" ]]; then
        mkdir -p "$INSTALL_DIR/commands"
        cp -r "$LANG_DIR/commands/"* "$INSTALL_DIR/commands/"
        # Fix permissions for command files
        chmod 644 "$INSTALL_DIR/commands"/*.md 2>/dev/null || true
        print_success "Installed commands"
    else
        print_warning "No commands directory found"
    fi

    # Copy scripts
    if [[ -d "$LANG_DIR/scripts" ]]; then
        mkdir -p "$INSTALL_DIR/scripts"
        cp -r "$LANG_DIR/scripts/"* "$INSTALL_DIR/scripts/"
        # Set execute permissions for scripts
        find "$INSTALL_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
        find "$INSTALL_DIR/scripts" -type f -name "*.ps1" -exec chmod +x {} \; 2>/dev/null || true
        print_success "Installed scripts"
    else
        print_warning "No scripts directory found"
    fi

    # Copy roles (if exists)
    if [[ -d "$LANG_DIR/roles" ]]; then
        cp -r "$LANG_DIR/roles" "$INSTALL_DIR/"
        print_success "Installed roles"
    fi

    # Copy hooks (if exists)
    if [[ -d "$LANG_DIR/hooks" ]]; then
        mkdir -p "$INSTALL_DIR/hooks"
        cp -r "$LANG_DIR/hooks/"* "$INSTALL_DIR/hooks/"
        print_success "Installed hooks"
    fi

    print_success "All files installed successfully"
}

#############################################################################
# Update Management
#############################################################################

update_mode() {
    print_info "Update mode: checking for updates..."

    # Get latest version from GitHub
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/putao520/cc-spec-lite/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' || echo "unknown")

    if [[ "$LATEST_VERSION" != "unknown" ]]; then
        print_info "Current version: ${VERSION}"
        print_info "Latest version: ${LATEST_VERSION}"

        if [[ "$VERSION" != "$LATEST_VERSION" ]]; then
            print_info "Update available!"
        fi
    else
        print_warning "Unable to check for updates"
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

    local errors=0

    # Check CLAUDE.md
    if [[ -f "$INSTALL_DIR/CLAUDE.md" ]]; then
        print_success "CLAUDE.md installed"
    else
        print_error "CLAUDE.md not found"
        ((errors++))
    fi

    # Check skills
    if [[ -d "$INSTALL_DIR/skills" ]] && [[ -n "$(ls -A $INSTALL_DIR/skills)" ]]; then
        SKILL_COUNT=$(find "$INSTALL_DIR/skills" -name "SKILL.md" | wc -l)
        print_success "Skills installed: ${SKILL_COUNT} skills"
    else
        print_error "No skills found"
        ((errors++))
    fi

    # Check commands
    if [[ -d "$INSTALL_DIR/commands" ]] && [[ -n "$(ls -A $INSTALL_DIR/commands)" ]]; then
        CMD_COUNT=$(find "$INSTALL_DIR/commands" -name "*.md" | wc -l)
        print_success "Commands installed: ${CMD_COUNT} commands"
    else
        print_warning "No commands found"
    fi

    # Check scripts
    if [[ -d "$INSTALL_DIR/scripts" ]] && [[ -n "$(ls -A $INSTALL_DIR/scripts)" ]]; then
        SCRIPT_COUNT=$(find "$INSTALL_DIR/scripts" -type f | wc -l)
        print_success "Scripts installed: ${SCRIPT_COUNT} files"
    else
        print_warning "No scripts found"
    fi

    # Check aiw
    if command -v aiw &> /dev/null; then
        AIW_VERSION=$(aiw --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown")
        print_success "aiw is available (v${AIW_VERSION})"
    else
        print_warning "aiw not found - some features may not work"
    fi

    return $errors
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
    $0 --lang en       # Install English version
    $0 --lang zh       # 安装中文版本
    $0 --update        # Update existing installation

Languages:
    en                 English (default)
    zh                 简体中文

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

    # Validate language choice
    if [[ -n "$LANG" && "$LANG" != "en" && "$LANG" != "zh" ]]; then
        print_error "Invalid language: $LANG"
        echo "Supported languages: en, zh"
        exit 1
    fi

    # Update mode
    if [[ "$UPDATE_MODE" == true ]]; then
        if [[ -z "$LANG" ]]; then
            # Detect current language from existing installation
            if [[ -f "$INSTALL_DIR/CLAUDE.md" ]]; then
                if grep -q "文档定位" "$INSTALL_DIR/CLAUDE.md"; then
                    LANG="zh"
                else
                    LANG="en"
                fi
                print_info "Detected language: $LANG"
            else
                LANG="en"
            fi
        fi
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
    if verify_installation; then
        # Print completion message
        echo ""
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║  Installation completed successfully!                       ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        print_info "Language: ${LANG}"
        print_info "Installation directory: ${INSTALL_DIR}"
        print_info "Backup location: ${BACKUP_DIR}"
        echo ""
        print_info "Next steps:"
        echo "  1. Restart Claude Code"
        echo "  2. Use /spec-init to initialize your project"
        echo ""
        print_info "Documentation: ${REPO_URL}"
        echo ""
    else
        print_error "Installation verification failed with ${errors} error(s)"
        exit 1
    fi
}

# Run main function
main "$@"
