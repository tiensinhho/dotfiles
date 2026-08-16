#!/bin/bash
echo "===== CÀI ĐẶT ZSH KHÔNG DÙNG OH-MY-ZSH ====="

# 1. Cài đặt Zsh nếu container chưa có
if ! command -v zsh &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y zsh git curl
fi

# 2. Tạo thư mục chứa các công cụ độc lập
mkdir -p ~/.zsh

# 3. Tải theme Powerlevel10k thẳng vào thư mục riêng
if [ ! -d "~/.zsh/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
fi

# 4. Tải các plugin độc lập
if [ ! -d "~/.zsh/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
fi

if [ ! -d "~/.zsh/zsh-syntax-highlighting" ]; then
    git https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# 5. Tạo liên kết file cấu hình
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "===== HOÀN TẤT ====="
# 5. Đồng bộ liên kết (Symlink) file cấu hình từ repo vào thư mục nhà (~)
echo "Đang tạo liên kết file cấu hình..."
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "===== CÀI ĐẶT DOTFILES HOÀN TẤT ====="
