# 1. Kích hoạt tính năng Instant Prompt của p10k (Giúp terminal hiện lên ngay lập tức)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. Nạp theme Powerlevel10k trực tiếp
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# 3. Nạp các tính năng cơ bản của hệ thống
autoload -Uz compinit && compinit

# 4. Nạp các plugin độc lập
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 5. Nạp cấu hình giao diện p10k của bạn
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
