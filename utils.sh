#!/bin/bash

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &> /dev/null
}

# Function to check if a package is installed
is_group_installed() {
  pacman -Qg "$1" &> /dev/null
}

# Function to install or update packages
# --needed skips packages already at latest version
# Packages that are outdated will be upgraded, missing ones — installed
install_packages() {
  local packages=("$@")
  if [ ${#packages[@]} -ne 0 ]; then
    echo "Installing/updating: ${packages[*]}"
    yay -S --needed --noconfirm "${packages[@]}"
  fi
}