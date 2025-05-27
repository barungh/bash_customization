#!/bin/bash

# =============================================================================
# Quick Installer for Enhanced Bash Environment
# =============================================================================
# This script downloads and runs the main setup script
# Usage: curl -fsSL https://raw.githubusercontent.com/barungh/bash_customization/master/install.sh | bash
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
REPO_URL="https://raw.githubusercontent.com/barungh/bash_customization/master"
SETUP_SCRIPT="setup-bash-environment.sh"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

main() {
    log_header "Enhanced Bash Environment Quick Installer"

    echo -e "${BLUE}This installer will download and run the setup script from:${NC}"
    echo -e "${YELLOW}${REPO_URL}/${SETUP_SCRIPT}${NC}\n"

    # Check for required tools
    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl is required but not installed. Please install curl first."
        exit 1
    fi

    # Download the setup script
    log_info "Downloading setup script..."

    local temp_script="/tmp/${SETUP_SCRIPT}"

    if curl -fsSL "${REPO_URL}/${SETUP_SCRIPT}" -o "$temp_script"; then
        log_success "Setup script downloaded successfully"
    else
        log_error "Failed to download setup script"
        exit 1
    fi

    # Make it executable
    chmod +x "$temp_script"

    # Run the setup script
    log_info "Running setup script..."
    echo -e "${YELLOW}You may be prompted for sudo password during installation.${NC}\n"

    "$temp_script"

    # Cleanup
    rm -f "$temp_script"

    log_success "Installation completed!"
}

# Run main function
main "$@"
