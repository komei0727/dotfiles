#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${CONFIG_DIR:-${HOME}/.config}"
WINDOWS_USER="${WINDOWS_USER:-User}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_info() { echo -e "${YELLOW}→${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_debug() { echo -e "${BLUE}…${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    else
        echo "unknown"
    fi
}

# Get platform-specific directories based on OS
get_platform_dirs() {
    local os_type="$1"
    local dirs=("common")

    case "$os_type" in
        wsl)
            dirs+=("linux" "wsl")
            ;;
        linux|darwin)
            dirs+=("$os_type")
            ;;
    esac

    echo "${dirs[@]}"
}

# Check if a config exists in platform-specific directories
find_config_source() {
    local config_name="$1"
    local os_type="$2"
    local platform_dirs=($(get_platform_dirs "$os_type"))

    # Check in reverse order (most specific first)
    for ((i=${#platform_dirs[@]}-1; i>=0; i--)); do
        local dir="${platform_dirs[$i]}"
        local path="${SCRIPT_DIR}/${dir}/${config_name}"

        if [ -e "$path" ]; then
            echo "$path"
            return 0
        fi
    done

    return 1
}

# Create direct symlink for a config
create_direct_link() {
    local source="$1"
    local target="$2"
    local config_name="$(basename "$source")"

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Remove existing link or directory
    if [ -L "$target" ] || [ -e "$target" ]; then
        rm -rf "$target"
    fi

    # Create symlink
    ln -fnsv "$source" "$target"
    log_success "Linked $config_name"
}

# Main linking logic
link_configs() {
    local os_type="$1"
    log_info "Setting up direct symlinks for platform: $os_type"

    # Get all unique config names across all platform directories
    local config_names=()
    for dir in common linux darwin wsl; do
        if [ -d "${SCRIPT_DIR}/${dir}" ]; then
            while IFS= read -r -d '' config; do
                config_names+=("$(basename "$config")")
            done < <(find "${SCRIPT_DIR}/${dir}" -mindepth 1 -maxdepth 1 -print0)
        fi
    done

    # Remove duplicates
    config_names=($(printf '%s\n' "${config_names[@]}" | sort -u))

    # Process each config
    for config_name in "${config_names[@]}"; do
        # Skip special directories
        if [[ "$config_name" == "windows_symlinks" || "$config_name" == "_merged" || "$config_name" == "link"* ]]; then
            continue
        fi

        # Skip Windows app configs in WSL (handled by manual sync)
        if [ "$os_type" = "wsl" ] && [[ "$config_name" =~ ^(Code|Cursor|alacritty)$ ]]; then
            log_debug "Skipping $config_name (use config-sync for Windows apps)"
            continue
        fi

        # Find the most specific version of this config
        if source_path=$(find_config_source "$config_name" "$os_type"); then
            local target_path="${CONFIG_DIR}/${config_name}"
            create_direct_link "$source_path" "$target_path"
        fi
    done
}

# Handle complex configs that need merging
handle_complex_configs() {
    local os_type="$1"
    local config_name="$2"

    log_info "Complex config detected: $config_name (requires merging)"

    # This function can be extended to handle specific cases where
    # file-level merging is needed (e.g., appending to files)
    # For now, we'll just use the most specific version
    if source_path=$(find_config_source "$config_name" "$os_type"); then
        local target_path="${CONFIG_DIR}/${config_name}"
        create_direct_link "$source_path" "$target_path"
    fi
}

# Check if a config has platform-specific overrides
has_overrides() {
    local config_name="$1"
    local count=0

    for dir in common linux darwin wsl; do
        if [ -e "${SCRIPT_DIR}/${dir}/${config_name}" ]; then
            ((count++))
        fi
    done

    [ $count -gt 1 ]
}

# Show status of current configuration
show_status() {
    log_info "Configuration Status:"

    # Check for configs with overrides
    local override_count=0
    for dir in "${SCRIPT_DIR}"/common/*; do
        if [ -d "$dir" ] || [ -f "$dir" ]; then
            local config_name="$(basename "$dir")"
            if has_overrides "$config_name"; then
                ((override_count++))
                log_debug "$config_name has platform-specific overrides"
            fi
        fi
    done

    if [ $override_count -eq 0 ]; then
        log_success "No platform-specific overrides detected (using direct symlinks)"
    else
        log_info "Found $override_count configs with platform-specific overrides"
    fi
}


# Main execution
main() {
    local os_type=$(detect_os)

    log_info "Detected OS: $os_type"

    # Show current status
    show_status

    # Create direct symlinks
    link_configs "$os_type"

    log_success "Configuration linking complete!"
    log_info "All configs are now directly symlinked - edits will be reflected immediately"
}

# Add help option
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --status   Show configuration status only"
    echo ""
    echo "Environment Variables:"
    echo "  CONFIG_DIR     Target directory for symlinks (default: ~/.config)"
    echo "  WINDOWS_USER   Windows username for WSL (default: User)"
    exit 0
fi

if [[ "$1" == "-s" ]] || [[ "$1" == "--status" ]]; then
    show_status
    exit 0
fi

main "$@"
