#!/bin/bash

set -euo pipefail

# Trap for clean error messages
trap 'echo "❌ An error occurred. Exiting..."; exit 1' ERR

setup_dev_env() {

  echo "🔧 Starting system customization and developer environment setup..."
  sleep 1

  echo "🚀 Installing Fastfetch..."
  sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
  sudo apt update
  sudo apt install fastfetch


  echo "🧬 Cloning mybash setup..."
  git clone https://github.com/christitustech/mybash
  cd mybash || exit
  ./setup.sh
  cd .. || exit

  echo "🌈 Configuring Starship prompt..."
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
  echo 'starship preset pastel-powerline -o ~/.config/starship.toml' >> ~/.bashrc

  # Check if zsh is installed
  if command -v zsh &> /dev/null; then
    echo "✅ Zsh detected. Installing plugins..."

    export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"

    echo "🔧 Updating ~/.zshrc plugins..."
    sed -i '/^plugins=/d' ~/.zshrc
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)' >> ~/.zshrc

  else
    echo "⚠️ Zsh is not installed."
    read -rp "Do you want to install and configure Zsh? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "🔧 Installing Zsh and recommended plugins..."
      sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting

      echo "📥 Installing Oh My Zsh..."
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

      export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

      git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
      git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
      git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"

      echo "🔧 Updating ~/.zshrc plugins..."
      sed -i '/^plugins=/d' ~/.zshrc
      echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)' >> ~/.zshrc

      echo 'eval "$(starship init zsh)"' >> ~/.zshrc
      starship preset pastel-powerline -o ~/.config/starship.toml

      echo "✅ Zsh setup complete. Restart your terminal or run \`zsh\` now."
    else
      echo "❌ Skipping Zsh installation."
    fi
  fi

  echo "🎉 All done!"
}
setup_dev_env
