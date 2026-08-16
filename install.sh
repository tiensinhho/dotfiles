#!/bin/bash
echo "===== START ====="

if [ "$(uname -s)" = "Linux" ]; then
    if ! command -v starship >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    fi
fi

ln -sf "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
mkdir -p "$HOME/.config"
ln -sf "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"

echo "===== END ====="
