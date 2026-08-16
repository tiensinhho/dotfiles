#!/bin/bash
echo "===== START ====="

if [ "$(uname -s)" = "Linux" ]; then
    if ! command -v starship >/dev/null 2>&1; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
fi

# 5. Tạo liên kết file cấu hình (Dùng đường dẫn tuyệt đối $HOME cho an toàn)
echo "Đang tạo liên kết file cấu hình..."

ln -sf "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"

echo "===== END ====="
