# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
echo "setting wallpapers"
gsettings set org.gnome.desktop.background picture-uri-dark "file://${SCRIPT_DIR}/dark.jpg"
gsettings set org.gnome.desktop.background picture-uri "file://${SCRIPT_DIR}/light.jpg"
gsettings set org.gnome.desktop.background picture-options 'zoom'
