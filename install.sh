#!/bin/bash

echo "===== ĐANG BẮT ĐẦU CÀI ĐẶT DOTFILES ====="

# 1. Kiểm tra và Cài đặt Zsh + Sudo/Curl nếu container thiếu
if ! command -v zsh &> /dev/null; then
    echo "Zsh chưa được cài. Đang tiến hành cài đặt Zsh..."
    sudo apt-get update && sudo apt-get install -y zsh git curl
fi

# 2. Cài đặt Oh My Zsh (Cài ở chế độ im lặng, không tự động bật shell)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Đang cài đặt Oh My Zsh..."
    sh -c "$(curl -fsSL https://githubusercontent.com)" "" --unattended
fi

# 3. Tải theme Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Đang tải theme Powerlevel10k..."
    git clone --depth=1 https://github.com "$P10K_DIR"
fi

# 4. Tải các Plugin (Autosuggestions & Syntax Highlighting)
SUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$SUGGEST_DIR" ]; then
    echo "Đang tải plugin zsh-autosuggestions..."
    git clone https://github.com "$SUGGEST_DIR"
fi

HIGHLIGHT_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$HIGHLIGHT_DIR" ]; then
    echo "Đang tải plugin zsh-syntax-highlighting..."
    git clone https://github.com "$HIGHLIGHT_DIR"
fi

# 5. Đồng bộ liên kết (Symlink) file cấu hình từ repo vào thư mục nhà (~)
echo "Đang tạo liên kết file cấu hình..."
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "===== CÀI ĐẶT DOTFILES HOÀN TẤT ====="
