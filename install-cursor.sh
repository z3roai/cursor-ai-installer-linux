#!/bin/bash

# Enhanced Cursor AI Installer: SVG icon, interactive steps, root permissions, error handling, uninstall, and more

set -euo pipefail

INSTALL_DIR="/opt"
APP_NAME="cursor.appimage"
ICON_PATH="$INSTALL_DIR/cursor.svg"
DESKTOP_FILE="/usr/share/applications/cursor.desktop"
APPIMAGE_TMP="/tmp/Cursor.AppImage"
ICON_URL="https://static.cdnlogo.com/logos/c/23/cursor.svg"

# Function for yes/no prompts
confirm() {
    while true; do
        read -p "$1 (y/n): " response
        case "$response" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

# Function to check for root
require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "⚠️  This step requires root privileges. Please enter your password if prompted."
    fi
}

# Function to uninstall Cursor AI
uninstall_cursor() {
    echo "🗑️  Uninstalling Cursor AI..."
    sudo rm -f "$INSTALL_DIR/$APP_NAME" "$ICON_PATH" "$DESKTOP_FILE"
    sudo update-desktop-database || true
    echo "✅ Cursor AI has been removed."
    exit 0
}

# Trap for cleanup on error
trap 'echo "❌ An error occurred. Exiting."' ERR

# --- Main Script ---

echo "🧠 Welcome to the Enhanced Cursor AI Interactive Installer"
echo "--------------------------------------------------------"

# Uninstall option
if [[ "${1:-}" == "uninstall" ]]; then
    uninstall_cursor
fi

# 1️⃣ Download AppImage
if confirm "➡️ Do you want to download a Cursor AppImage from a URL?"; then
    read -p "🔗 Enter the full .AppImage URL: " APPIMAGE_URL
    if [[ -z "$APPIMAGE_URL" ]]; then
        echo "❌ URL is empty. Skipping download."
    else
        echo "📥 Downloading Cursor from $APPIMAGE_URL..."
        if ! curl -L "$APPIMAGE_URL" -o "$APPIMAGE_TMP"; then
            echo "❌ Download failed. Please check the URL."
            exit 1
        fi
        chmod +x "$APPIMAGE_TMP"
        echo "✅ Downloaded to $APPIMAGE_TMP"
    fi
else
    echo "⏭️ Skipping download step."
fi

# 2️⃣ Install required packages
if confirm "🛠️ Do you want to install required packages (libfuse2, etc.)?"; then
    require_root
    if command -v apt &>/dev/null; then
        sudo apt update
        sudo apt install -y libfuse2 desktop-file-utils curl wget
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y fuse2 desktop-file-utils curl wget
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm fuse2 desktop-file-utils curl wget
    else
        echo "❌ No supported package manager found. Please install dependencies manually."
    fi
else
    echo "⏭️ Skipping package installation."
fi

# 3️⃣ Move AppImage to /opt
if confirm "📦 Do you want to move the AppImage to $INSTALL_DIR/$APP_NAME?"; then
    if [[ ! -f "$APPIMAGE_TMP" ]]; then
        read -p "🔍 AppImage not found in /tmp. Enter full path to your AppImage: " LOCAL_PATH
        if [[ ! -f "$LOCAL_PATH" ]]; then
            echo "❌ File not found: $LOCAL_PATH"
            exit 1
        fi
    else
        LOCAL_PATH="$APPIMAGE_TMP"
    fi
    require_root
    sudo mkdir -p "$INSTALL_DIR"
    sudo mv "$LOCAL_PATH" "$INSTALL_DIR/$APP_NAME"
    sudo chmod +x "$INSTALL_DIR/$APP_NAME"
    echo "✅ AppImage moved to $INSTALL_DIR/$APP_NAME"
else
    echo "⏭️ Skipping file move step."
fi

# 4️⃣ Download SVG icon
if confirm "🖼️ Do you want to download the Cursor SVG icon?"; then
    require_root
    if wget -qO "$ICON_PATH" "$ICON_URL"; then
        echo "✅ SVG Icon downloaded to $ICON_PATH"
    else
        echo "❌ Failed to download icon."
    fi
else
    echo "⏭️ Skipping icon download."
fi

# 5️⃣ Create desktop entry
if confirm "🖥️ Do you want to create a desktop launcher for Cursor?"; then
    require_root
    sudo tee "$DESKTOP_FILE" > /dev/null <<EOF
[Desktop Entry]
Name=Cursor AI
Exec=$INSTALL_DIR/$APP_NAME --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
StartupNotify=true
Terminal=false
EOF
    sudo chmod 644 "$DESKTOP_FILE"
    echo "✅ Launcher created at $DESKTOP_FILE"
else
    echo "⏭️ Skipping launcher creation."
fi

# 6️⃣ Update application menu
if confirm "🔄 Do you want to update the desktop application database?"; then
    require_root
    if command -v update-desktop-database &>/dev/null; then
        sudo update-desktop-database
        echo "✅ Desktop database updated."
    else
        echo "⚠️  update-desktop-database not found. Please update your desktop database manually if needed."
    fi
else
    echo "⏭️ Skipping desktop database update."
fi

# 7️⃣ (Optional) Add to PATH
if confirm "➕ Do you want to symlink Cursor AI to /usr/local/bin for easy CLI access?"; then
    require_root
    sudo ln -sf "$INSTALL_DIR/$APP_NAME" /usr/local/bin/cursor-ai
    echo "✅ You can now run 'cursor-ai --no-sandbox' from the terminal."
else
    echo "⏭️ Skipping symlink step."
fi

# 🎉 Wrap-up
echo ""
echo "✅ Done! Cursor AI installation process is complete."
echo "🚀 Launch Cursor AI from your app menu or run:"
echo "$INSTALL_DIR/$APP_NAME --no-sandbox"
echo ""
echo "🧹 To uninstall, run: sudo bash $0 uninstall"
