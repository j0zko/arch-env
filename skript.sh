#!/bin/bash

set -e

REPO_URL="https://github.com/j0zko/arch-env.git"
CLONE_DIR="$HOME/arch-env"
PERSONAL_DIR="$HOME/personal"

TOP_LEVEL_COMPONENTS=(rofi dunst)
HYPRLAND_TOOLS=(hyprlock hypridle hyprpaper hyprshot)
WAYBAR_DIR="$HOME/.config/waybar"

echo "📥 Cloning your repo..."
git clone "$REPO_URL" "$CLONE_DIR" || { echo "❌ Repo clone failed"; exit 1; }

# Install yay and paru (AUR helpers)
install_aur_helpers() {
    cd /tmp || exit
    for helper in yay paru; do
        if ! command -v "$helper" &>/dev/null; then
            echo "🔧 Installing AUR helper: $helper"
            git clone "https://aur.archlinux.org/$helper.git"
            cd "$helper"
            makepkg -si --noconfirm
            cd ..
            rm -rf "$helper"
        else
            echo "✅ $helper is already installed"
        fi
    done
}

# Install packages using yay or paru
install_package() {
    local pkg="$1"
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "✅ $pkg is already installed"
    else
        echo "📦 Installing $pkg"
        if command -v yay &>/dev/null; then
            yay -S --noconfirm "$pkg"
        elif command -v paru &>/dev/null; then
            paru -S --noconfirm "$pkg"
        else
            echo "❌ No AUR helper found for $pkg"
        fi
    fi
}

echo "🛠️ Installing yay and paru if needed..."
install_aur_helpers

ALL_COMPONENTS=(rofi waybar dunst hyprlock hypridle hyprpaper hyprshot)
echo "📦 Installing required components..."
for pkg in "${ALL_COMPONENTS[@]}"; do
    install_package "$pkg"
done

mkdir -p "$HOME/.config"

echo "🔧 Setting up top-level configs: rofi, dunst"
for comp in "${TOP_LEVEL_COMPONENTS[@]}"; do
    CONFIG_PATH="$HOME/.config/$comp"
    echo "📁 Setting up $CONFIG_PATH"
    mkdir -p "$CONFIG_PATH"
    if [ -d "$CLONE_DIR/$comp" ]; then
        ln -sf "$CLONE_DIR/$comp/"* "$CONFIG_PATH/"
    fi
done

echo "🔧 Setting up hyprland tools configs..."
for tool in "${HYPRLAND_TOOLS[@]}"; do
    TOOL_PATH="$HOME/.config/$tool"
    REPO_PATH="$CLONE_DIR/hyprland/$tool"
    mkdir -p "$TOOL_PATH"
    if [ -d "$REPO_PATH" ]; then
        ln -sf "$REPO_PATH/"* "$TOOL_PATH/"
    fi
done

echo "🛠️ Creating waybar directory and adding config files..."
mkdir -p "$WAYBAR_DIR"
if [ -f "$CLONE_DIR/config.jsonc.txt" ]; then
    mv "$CLONE_DIR/config.jsonc.txt" "$WAYBAR_DIR/config.jsonc"
fi
if [ -f "$CLONE_DIR/style.css.txt" ]; then
    mv "$CLONE_DIR/style.css.txt" "$WAYBAR_DIR/style.css"
fi

echo "👤 Creating personal directory: $PERSONAL_DIR"
mkdir -p "$PERSONAL_DIR"

echo "✅ Setup complete! You're ready to go."
