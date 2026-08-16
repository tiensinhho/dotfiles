#!/bin/bash

# 1. Cài đặt Oh My Zsh (nếu chưa có)
if [ ! -d "$HOME/oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://githubusercontent.com)" "" --unattended
fi

# 2. Cài đặt Theme Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 3. Cài đặt Plugins
git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 4. Liên kết (Symlink) các file cấu hình từ repo dotfiles vào thư mục Home
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
