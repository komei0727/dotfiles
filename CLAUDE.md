# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for managing development environment configurations, optimized for WSL (Windows Subsystem for Linux) environments. The repository uses symlinks to manage configuration files across different locations.

## Common Commands

### Environment Setup
- `make all` - Complete environment setup (runs link, brew, and config targets)
- `make link` - Symlinks main dotfiles from `.bin/` to `$HOME`
- `make brew` - Installs packages via Homebrew (automatically selects `.Brewfile.darwin` or `.Brewfile.linux` based on OS)
- `make config` - Symlinks config files from `.config/` to `~/.config/`

### Manual Setup Requirements
Before running `make all`, these tools must be installed manually:
```bash
# Install Sheldon (ZSH plugin manager)
curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Architecture and Structure

### Directory Organization
- `.bin/` - Main dotfiles and platform-specific Brewfiles
  - `.Brewfile.darwin` - macOS-specific packages
  - `.Brewfile.linux` - Linux/WSL packages
  - `.zshrc`, `.vimrc`, `.gitconfig` - Shell and editor configs
- `.config/` - XDG config directory files with platform-specific structure
  - `common/` - Shared configurations for all platforms
  - `linux/` - Linux-specific configurations
  - `darwin/` - macOS-specific configurations
  - `wsl/` - WSL-specific configurations and Windows symlink mappings
- `zsh/` - ZSH-specific configurations and plugins

### Platform-Specific Configuration Strategy
This repository uses a layered configuration approach to support multiple platforms:

1. **Common Layer**: Base configurations shared across all platforms (`common/`)
2. **Platform Layer**: OS-specific overrides (`linux/`, `darwin/`, `wsl/`)
3. **Merge Process**: `link.sh` scripts automatically merge configurations based on detected OS
4. **Git Management**: Only source directories are tracked; generated `_merged/` directories are excluded

### Linking Strategy
1. **Main dotfiles**: `.bin/link.sh` symlinks all hidden files (except `.git`, `.github`, `.config`) to `$HOME`
2. **Config files**: `.config/link.sh` merges platform-specific configs and creates symlinks:
   - Detects OS type (WSL, Linux, macOS)
   - Overlays platform-specific configs
3. **Windows configs**: For WSL, syncs Windows application configs via `mapping.yaml`

### Key Components

#### Shell Environment
- **ZSH** with Powerlevel10k theme
- **Sheldon** for plugin management (config: `zsh/sheldon/plugins.toml`)
- **zsh-defer** for lazy loading to improve startup performance
- Plugins: fzf-tab, syntax highlighting, autosuggestions, completions, abbreviations

#### Package Management
- **Homebrew** packages: bat, eza, fd, fzf, mise, navi, tmux, uv
- **mise** for runtime version management (Node.js, Python)
- **npm packages**: claude-code, ccusage (managed via mise)

#### Custom Functions
- `claude-tilex` - Creates multiple tmux panes with git worktrees for parallel Claude sessions
- `create_session_with_ghq` - tmux session management with ghq repositories
- `navipopup` - tmux popup for navi cheatsheet
- `fcd` - fuzzy directory navigation
- `fgc` - fuzzy git branch checkout

## Important Notes

1. This repository is designed for WSL environments with Windows integration
2. The `windows_config/link.sh` expects Windows user path at `/mnt/c/Users/User/AppData/Roaming/`
3. All shell configurations use lazy loading via zsh-defer for performance
4. The repository includes tmux configuration with custom keybindings (C-a prefix)
5. Git worktree workflow is integrated for parallel development
