# !/bin/bash

SCRIPT_DIR="${HOME}/dotfiles/.config"

if cd "$SCRIPT_DIR"; then
    for file in $(find . '(' -not -path '*.git*' ')' -and '(' -path '*.json' -o -path '*toml' -o -path '*.conf' ')' -type f -print | cut -b3-)
    do
        target="${HOME}/.config/${file}"
        source="${SCRIPT_DIR}/${file}"
        target_dir=$(dirname "$target")

        mkdir -p "$target_dir"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            echo "Skipping $file (already linked)"
        else
            ln -fnsv "$source" "$target"
        fi
    done
else
    echo "Failed to cd to $SCRIPT_DIR"
    exit 1
fi