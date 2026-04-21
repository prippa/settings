#!/usr/bin/env bash

FLATPAKS=(
  "com.google.Chrome"               # Google Chrome
  "org.remmina.Remmina"             # RDP-клиент (Remmina)
  "com.obsproject.Studio"           # OBS Studio
  "com.anydesk.Anydesk"             # AnyDesk
  "com.getpostman.Postman"          # Postman
  "io.dbeaver.DBeaverCommunity"     # DBeaver DB viewer #1
  "com.mongodb.Compass"             # MongoDB Cmpass DB viewer #2
  "org.flameshot.Flameshot"         # Flameshot
  "com.mattermost.Desktop"          # Mattermost Desktop
  "com.github.sdv43.whaler"         # Whaler (Docker GUI)
)

# Добавим Flathub, если ещё не добавлен
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update all installed flatpaks first
echo "Updating all installed Flatpaks..."
flatpak update -y

# Install or update each flatpak (--or-update upgrades if already installed)
for pak in "${FLATPAKS[@]}"; do
  echo "Installing/updating Flatpak: $pak"
  flatpak install --or-update -y flathub "$pak"
done
