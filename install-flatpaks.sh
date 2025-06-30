#!/usr/bin/env bash

FLATPAKS=(
  "com.google.Chrome"               # Google Chrome
  "org.remmina.Remmina"             # RDP-клиент (Remmina)
  "com.obsproject.Studio"           # OBS Studio
  "com.anydesk.Anydesk"             # AnyDesk
  "com.getpostman.Postman"          # Postman
  "io.dbeaver.DBeaverCommunity"     # DBeaver
  "org.flameshot.Flameshot"         # Flameshot
  "com.mattermost.Desktop"          # Mattermost Desktop
  "com.github.sdv43.whaler"         # Whaler (Docker GUI)
)

# Добавим Flathub, если ещё не добавлен
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for pak in "${FLATPAKS[@]}"; do
  if ! flatpak list | grep -i "$pak" &> /dev/null; then
    echo "Installing Flatpak: $pak"
    flatpak install -y "$pak"
  else
    echo "Flatpak already installed: $pak"
  fi
done
