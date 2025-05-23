#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for dotfile in "${SCRIPT_DIR}"/.??*; do
    [ "$dotfile" = "${SCRIPT_DIR}/.git" ] && continue
    [ "$dotfile" = "${SCRIPT_DIR}/.github" ] && continue
    [ "$dotfile" = "${SCRIPT_DIR}/.config" ] && continue

    ln -fnsv "$dotfile" "$HOME"
done