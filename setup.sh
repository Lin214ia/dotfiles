#!/bin/bash
set -e # エラーが出たら止める

echo "🔧 Starting setup..."

# 1. 基本ツールの更新とインストール
echo "📦 Installing basics..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl git unzip wget software-properties-common

# 2. Fish & Starship
echo "🐠 Installing Fish & Starship..."
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt update
sudo apt install -y fish
curl -sS https://starship.rs/install.sh | sh -s -- -y

# 3. モダンツール群 (Rust製)
echo "🦀 Installing Modern Tools..."
# Eza (ls replacement)
sudo apt install -y gpg
mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza bat ripgrep fd-find

# Batのリンク修正
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat

# 4. Zellij (Binary install)
echo "💻 Installing Zellij..."
if ! command -v zellij &> /dev/null; then
    curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
    sudo mv zellij /usr/local/bin/
fi

# 5. uv (Python)
echo "🐍 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# 6. GitHub CLI
echo "🐙 Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
fi

# 7. Stowで設定反映
echo "🔗 Linking dotfiles..."
sudo apt install -y stow
stow .

echo "✨ Setup Complete! Please restart your shell."
