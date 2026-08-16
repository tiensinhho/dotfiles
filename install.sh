#!/bin/bash
echo "===== CÀI ĐẶT ZSH KHÔNG DÙNG OH-MY-ZSH ====="

# Tự động nhận diện có cần dùng sudo hay không
if command -v sudo &> /dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

# 1. Cài đặt Zsh nếu container chưa có
if ! command -v zsh &> /dev/null; then
    echo "Zsh chưa được cài. Đang tiến hành cài đặt Zsh..."
    $SUDO apt-get update && $SUDO apt-get install -y zsh git curl
fi

# 2. Tạo thư mục chứa các công cụ độc lập (Dùng dấu ngoặc kép để nhận diện dấu ~ đúng cách)
mkdir -p "$HOME/.zsh"

# 3. Tải theme Powerlevel10k thẳng vào thư mục riêng
if [ ! -d "$HOME/.zsh/powerlevel10k" ]; then
    echo "Đang tải theme Powerlevel10k..."
    git clone --depth=1 https://github.com "$HOME/.zsh/powerlevel10k"
fi

# 4. Tải các plugin độc lập
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Đang tải plugin zsh-autosuggestions..."
    git clone https://github.com "$HOME/.zsh/zsh-autosuggestions"
fi

if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "Đang tải plugin zsh-syntax-highlighting..."
    git clone https://github.com "$HOME/.zsh/zsh-syntax-highlighting"
fi

# 5. Tạo liên kết file cấu hình (Dùng đường dẫn tuyệt đối $HOME cho an toàn)
echo "Đang tạo liên kết file cấu hình..."
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"

echo "===== HOÀN TẤT ====="
