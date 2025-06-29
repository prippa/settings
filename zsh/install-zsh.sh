#!/usr/bin/env bash

# Script to install Zsh, Oh My Zsh, and plugins: zsh-autosuggestions, zsh-syntax-highlighting, powerlevel10k
# Designed for Arch Linux with sudo privileges

set -euo pipefail

# Check for sudo/root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo"
  exit 1
fi

# Variables
USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$USER_NAME")
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

# Install Zsh
if ! command -v zsh >/dev/null 2>&1; then
  echo "Installing zsh..."
  yay -S --noconfirm zsh
else
  echo "zsh is already installed"
fi

# Install Oh My Zsh
if [[ ! -d "$USER_HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sudo -u "$USER_NAME" sh -c "
    export RUNZSH=no
    git clone https://github.com/ohmyzsh/ohmyzsh.git '$USER_HOME/.oh-my-zsh'
  "
else
  echo "Oh My Zsh is already installed"
fi

# Function to install plugin from GitHub
install_plugin() {
  local repo_url="$1"
  local plugin_dir="$2"
  if [[ ! -d "$plugin_dir" ]]; then
    echo "Installing plugin from $repo_url..."
    sudo -u "$USER_NAME" git clone "$repo_url" "$plugin_dir"
  else
    echo "Plugin already installed in $plugin_dir"
  fi
}

# Install plugins
install_plugin https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
install_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
install_plugin https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# Update .zshrc
ZSHRC_FILE="$USER_HOME/.zshrc"

# Create .zshrc if it does not exist
if [[ ! -f "$ZSHRC_FILE" ]]; then
  echo "Creating .zshrc..."
  sudo -u "$USER_NAME" cp "$USER_HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$ZSHRC_FILE"
else
  echo ".zshrc already exists"
fi

# Add plugins to .zshrc if not present
if ! grep -q "zsh-autosuggestions" "$ZSHRC_FILE"; then
  echo "Adding plugins to .zshrc..."
  sudo -u "$USER_NAME" sed -i "/^plugins=/ s/)$/ zsh-autosuggestions zsh-syntax-highlighting)/" "$ZSHRC_FILE"
else
  echo "Plugins already present in .zshrc"
fi

# Set ZSH_THEME to powerlevel10k
if grep -q '^ZSH_THEME=' "$ZSHRC_FILE"; then
  sudo -u "$USER_NAME" sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC_FILE"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' | sudo -u "$USER_NAME" tee -a "$ZSHRC_FILE" >/dev/null
fi

# Set zsh as default shell
CURRENT_SHELL=$(getent passwd "$USER_NAME" | cut -d: -f7)
if [[ "$CURRENT_SHELL" != "/usr/bin/zsh" ]]; then
  echo "Changing default shell for $USER_NAME to zsh..."
  chsh -s /usr/bin/zsh "$USER_NAME"
else
  echo "zsh is already the default shell"
fi

# Done
echo "Installation complete. Restart the terminal to apply changes."
