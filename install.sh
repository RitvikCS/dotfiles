#!/usr/bin/env bash
# Arch + Hyprland (Catppuccin Mocha) dotfiles installer.
# Symlinks configs from this repo into $HOME, installs packages and fonts.
# Re-runnable: existing non-symlink files are backed up first.
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ask() { read -rp "$1 [y/N] " a; [[ ${a,,} == y* ]]; }

# ---------- packages ----------
if ask "Install packages (pacman + AUR via yay)?"; then
    say "Installing official packages"
    grep -vE '^\s*(#|$)' "$DOTS/packages/pacman.txt" | sudo pacman -S --needed -

    if ! command -v yay >/dev/null; then
        say "Installing yay (AUR helper)"
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
    say "Installing AUR packages"
    grep -vE '^\s*(#|$)' "$DOTS/packages/aur.txt" | xargs yay -S --needed
fi

# ---------- symlinks ----------
link() { # link <repo-relative-src> <absolute-dst>
    local src="$DOTS/$1" dst="$2" rel
    mkdir -p "$(dirname "$dst")"
    if [[ -e $dst && ! -L $dst ]]; then
        rel="${dst#"$HOME"/}"
        mkdir -p "$BACKUP/$(dirname "$rel")"
        mv "$dst" "$BACKUP/$rel"
        say "backed up existing $dst"
    fi
    ln -sfnT "$src" "$dst"
    say "linked $dst"
}

say "Linking configs (anything replaced goes to $BACKUP)"
for d in hypr waybar rofi mako waypaper ghostty Kvantum qt6ct; do
    link "config/$d" "$HOME/.config/$d"
done
link config/gtk-3.0/settings.ini "$HOME/.config/gtk-3.0/settings.ini"
link config/gtk-4.0/settings.ini "$HOME/.config/gtk-4.0/settings.ini"
link config/kdeglobals           "$HOME/.config/kdeglobals"
link config/mimeapps.list        "$HOME/.config/mimeapps.list"
link home/bash_profile           "$HOME/.bash_profile"
link home/bashrc                 "$HOME/.bashrc"

# ---------- fonts ----------
# Icomoon-Feather = rofi powermenu icons; Bebas Neue = hyprlock clock.
say "Installing bundled fonts"
mkdir -p "$HOME/.local/share/fonts"
cp -f "$DOTS/fonts/"*.ttf "$HOME/.local/share/fonts/"
fc-cache -f >/dev/null
# Nerd Fonts v2 "Complete" TTFs shadow the system v3 JetBrainsMono and break rofi glyphs.
if find "$HOME/.local/share/fonts" -iname "*nerd*complete*" | grep -q .; then
    echo "WARNING: Nerd Fonts v2 'Complete' TTFs found in ~/.local/share/fonts —"
    echo "         delete them or rofi/waybar icons will render wrong (v2 shadows v3)."
fi

# ---------- settings not stored in files ----------
say "Applying gsettings (GTK theme / icons / dark mode)"
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark'     || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'   || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'  || true

mkdir -p "$HOME/Pictures/wallpapers"   # waypaper library (Super+W)

# ---------- system-level (sudo) ----------
if ask "Enable NetworkManager + Bluetooth services (sudo)?"; then
    sudo systemctl enable --now NetworkManager bluetooth
fi

if ask "Install getty@tty1 autologin (sudo)? Boot flow: autologin -> bash_profile execs Hyprland -> hyprlock"; then
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sed "s/--autologin [a-z0-9_-]*/--autologin $USER/" "$DOTS/system/getty-autologin.conf" \
        | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null
    sudo systemctl daemon-reload
    say "Autologin installed for user: $USER"
fi

say "Done."
echo "  - Reboot (or log out) to start Hyprland."
echo "  - Drop wallpapers into ~/Pictures/wallpapers, pick one with Super+W."
echo "  - NVIDIA users: env vars live in config/hypr/modules/env.lua (already set up)."
echo "  - Non-NVIDIA users: comment out the nvidia lines in config/hypr/modules/env.lua."
echo "  - Check config/hypr/modules/monitors.lua matches your display."
