#!/bin/bash
set -e

echo "[*] Updating system..."
sudo xbps-install -Syu

echo "[*] Installing Hyprland + dependencies..."
sudo xbps-install -Sy \
  hyprland waybar rofi kitty xorg-server-xwayland \
  xorg-minimal xorg-fonts xf86-input-libinput \
  mesa-dri mesa-vulkan-intel \
  wayland wayland-protocols \
  seatd elogind dbus-elogind \
  nwg-look grim slurp wl-clipboard \
  brightnessctl playerctl

echo "[*] Enabling essential services..."
for svc in dbus seatd elogind; do
  if [ ! -e /var/service/$svc ]; then
    sudo ln -s /etc/sv/$svc /var/service
  fi
done

echo "[*] Adding $USER to seat group..."
sudo usermod -aG seat $USER

echo "[*] Creating default config directories..."
mkdir -p ~/.config/{hypr,waybar,rofi}

if [ ! -f ~/.config/hypr/hyprland.conf ]; then
  echo "[*] Writing basic Hyprland config..."
  cat > ~/.config/hypr/hyprland.conf <<EOF
exec = waybar
exec = rofi -show drun
EOF
fi

echo
echo "✅ Done! Please reboot or logout/login, then run 'Hyprland'."
