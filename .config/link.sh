#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${HOME}/.config"
MERGED_DIR="${SCRIPT_DIR}/_merged"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_info() { echo -e "${YELLOW}→${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version; then
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

# Clean merged directory
clean_merged() {
    log_info "Cleaning merged directory..."
    rm -rf "$MERGED_DIR"
    mkdir -p "$MERGED_DIR"
}

# Copy or merge config files based on platform
merge_configs() {
    local os_type="$1"
    log_info "Merging configs for platform: $os_type"

    # First, copy all common configs
    if [ -d "${SCRIPT_DIR}/common" ]; then
        log_info "Copying common configs..."
        cp -r "${SCRIPT_DIR}/common/"* "$MERGED_DIR/" 2>/dev/null || true
    fi

    # Then, overlay platform-specific configs
    if [ "$os_type" = "wsl" ]; then
        # For WSL, first apply linux configs, then wsl configs
        if [ -d "${SCRIPT_DIR}/linux" ]; then
            log_info "Applying Linux-specific configs..."
            cp -r "${SCRIPT_DIR}/linux/"* "$MERGED_DIR/" 2>/dev/null || true
        fi
        if [ -d "${SCRIPT_DIR}/wsl" ]; then
            log_info "Applying WSL-specific configs..."
            cp -r "${SCRIPT_DIR}/wsl/"* "$MERGED_DIR/" 2>/dev/null || true
        fi
    elif [ "$os_type" = "linux" ] || [ "$os_type" = "darwin" ]; then
        if [ -d "${SCRIPT_DIR}/${os_type}" ]; then
            log_info "Applying ${os_type}-specific configs..."
            cp -r "${SCRIPT_DIR}/${os_type}/"* "$MERGED_DIR/" 2>/dev/null || true
        fi
    fi
}

# Create symlinks for regular configs
create_regular_links() {
    log_info "Creating symlinks in ~/.config..."
    
    # Find all directories in _merged
    find "$MERGED_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
        local dirname="$(basename "$dir")"
        
        # Skip special directories
        if [ "$dirname" = "windows_symlinks" ]; then
            continue
        fi
        
        local target="${CONFIG_DIR}/${dirname}"
        
        # Create parent directory if needed
        mkdir -p "$(dirname "$target")"
        
        # Remove existing link or directory
        if [ -L "$target" ] || [ -e "$target" ]; then
            rm -rf "$target"
        fi
        
        # Create symlink
        ln -fnsv "$dir" "$target"
        log_success "Linked $dirname"
    done
}

# Create Windows symlinks for WSL
create_windows_links() {
    local mapping_file="${SCRIPT_DIR}/wsl/windows_symlinks/mapping.yaml"
    
    if [ ! -f "$mapping_file" ]; then
        log_info "No Windows symlink mappings found, skipping..."
        return
    fi
    
    log_info "Syncing Windows configurations for WSL..."
    
    # Parse mapping.yaml and create symlinks
    # Note: This is a simple implementation. For production, consider using a YAML parser
    while IFS= read -r line; do
        if [[ "$line" =~ source:\ (.+) ]]; then
            source_path="${BASH_REMATCH[1]}"
            source_path="${source_path// /}"  # Remove spaces
            source_full="${SCRIPT_DIR}/${source_path}"
        elif [[ "$line" =~ target:\ (.+) ]]; then
            target_path="${BASH_REMATCH[1]}"
            target_path="${target_path// /}"  # Remove spaces
            
            if [ -n "$source_full" ] && [ -f "$source_full" ]; then
                # Create parent directory
                mkdir -p "$(dirname "$target_path")"
                
                # Step 1: Copy config file to Windows side
                log_info "Copying $(basename "$source_full") to Windows..."
                cp -f "$source_full" "$target_path" 2>/dev/null || {
                    log_error "Cannot copy to $target_path"
                    continue
                }
                
                # Step 2: Remove existing file in _merged and create symlink from Windows
                if [ -f "$source_full" ]; then
                    rm -f "$source_full"
                fi
                
                # Create symlink from Windows file to _merged
                ln -fnsv "$target_path" "$source_full"
                log_success "Linked $(basename "$source_full") from Windows"
            fi
        fi
    done < "$mapping_file"
}

# Main execution
main() {
    local os_type=$(detect_os)
    
    log_info "Detected OS: $os_type"
    
    # Clean and prepare merged directory
    clean_merged
    
    # Merge configs based on platform
    merge_configs "$os_type"
    
    # Create regular symlinks
    create_regular_links
    
    # Create Windows symlinks if WSL
    if [ "$os_type" = "wsl" ]; then
        create_windows_links
    fi
    
    log_success "Configuration linking complete!"
}

main "$@"