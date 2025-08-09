#!/bin/bash
set -euo pipefail

ICON_PATH="/opt/cursor.svg"
DESKTOP_FILE="/usr/share/applications/cursor.desktop"
APPIMAGE_TMP="/tmp/Cursor.AppImage"
ICON_URL="https://static.cdnlogo.com/logos/c/23/cursor.svg"

# Global variable to hold the user-provided full AppImage path
TARGET_APPIMAGE_PATH=""

confirm_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "⚠️  This step requires root privileges. Please enter your password if prompted."
    fi
}

uninstall_cursor() {
    echo "🗑️  Uninstalling Cursor AI..."
    if [[ -n "$TARGET_APPIMAGE_PATH" ]]; then
        sudo rm -f "$TARGET_APPIMAGE_PATH"
    else
        echo "⚠️ AppImage path unknown, skipping removal of AppImage file."
    fi
    sudo rm -f "$ICON_PATH" "$DESKTOP_FILE"
    sudo update-desktop-database || true
    echo "✅ Cursor AI has been removed."
}

download_appimage() {
    read -p "🔗 Enter the full .AppImage URL: " APPIMAGE_URL
    if [[ -z "$APPIMAGE_URL" ]]; then
        echo "❌ URL cannot be empty. Aborting download."
        return 1
    fi
    echo "📥 Downloading Cursor AppImage..."
    curl -L "$APPIMAGE_URL" -o "$APPIMAGE_TMP"
    chmod +x "$APPIMAGE_TMP"
    echo "✅ Downloaded to $APPIMAGE_TMP"
}

install_packages() {
    confirm_root
    if command -v apt &>/dev/null; then
        sudo apt update
        sudo apt install -y libfuse2 desktop-file-utils curl wget
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y fuse2 desktop-file-utils curl wget
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm fuse2 desktop-file-utils curl wget
    else
        echo "❌ No supported package manager found."
    fi
}

move_appimage() {
    confirm_root
    read -p "🔍 Enter full target path for the AppImage (including filename), e.g. /opt/cursor.appimage: " TARGET_APPIMAGE_PATH
    if [[ -z "$TARGET_APPIMAGE_PATH" ]]; then
        echo "❌ No target path provided."
        return 1
    fi

    read -p "🔍 Enter full path to your existing AppImage file to move: " LOCAL_PATH
    if [[ ! -f "$LOCAL_PATH" ]]; then
        echo "❌ File not found: $LOCAL_PATH"
        return 1
    fi

    sudo mkdir -p "$(dirname "$TARGET_APPIMAGE_PATH")"
    sudo mv "$LOCAL_PATH" "$TARGET_APPIMAGE_PATH"
    sudo chmod +x "$TARGET_APPIMAGE_PATH"
    echo "✅ AppImage moved to $TARGET_APPIMAGE_PATH"
}

download_icon() {
    confirm_root
    TMP_ICON="/tmp/cursor.svg"
    echo "📥 Downloading SVG icon to temporary location..."
    if wget -qO "$TMP_ICON" "$ICON_URL"; then
        echo "✅ Downloaded SVG icon to $TMP_ICON"
        echo "📂 Moving SVG icon to $ICON_PATH (requires admin)..."
        sudo mv "$TMP_ICON" "$ICON_PATH"
        sudo chmod 644 "$ICON_PATH"
        echo "✅ SVG icon installed at $ICON_PATH"
    else
        echo "❌ Failed to download SVG icon."
        rm -f "$TMP_ICON"
        return 1
    fi
}

create_launcher() {
    confirm_root
    if [[ -z "$TARGET_APPIMAGE_PATH" ]]; then
        echo "❌ AppImage path not set. Please run the move step first."
        return 1
    fi

    sudo tee "$DESKTOP_FILE" > /dev/null <<EOF
[Desktop Entry]
Name=Cursor AI
Exec=$TARGET_APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
StartupNotify=true
Terminal=false
EOF
    sudo chmod 644 "$DESKTOP_FILE"
    echo "✅ Launcher created at $DESKTOP_FILE"
}

update_desktop_db() {
    confirm_root
    if command -v update-desktop-database &>/dev/null; then
        sudo update-desktop-database
        echo "✅ Desktop database updated."
    else
        echo "⚠️ update-desktop-database not found. Please update manually if needed."
    fi
}

add_symlink() {
    confirm_root
    if [[ -z "$TARGET_APPIMAGE_PATH" ]]; then
        echo "❌ AppImage path not set. Please run the move step first."
        return 1
    fi

    sudo ln -sf "$TARGET_APPIMAGE_PATH" /usr/local/bin/cursor-ai
    echo "✅ You can now run 'cursor-ai --no-sandbox' from the terminal."
}

echo "🧠 Cursor AI Installer"
echo "Select a step to run:"
echo "1) Download AppImage"
echo "2) Install packages"
echo "3) Move AppImage to target directory"
echo "4) Download SVG icon"
echo "5) Create desktop launcher"
echo "6) Update desktop database"
echo "7) Add symlink for CLI access"
echo "8) Uninstall Cursor AI"
read -p "Enter step number: " choice

case $choice in
    1) download_appimage ;;
    2) install_packages ;;
    3) move_appimage ;;
    4) download_icon ;;
    5) create_launcher ;;
    6) update_desktop_db ;;
    7) add_symlink ;;
    8) uninstall_cursor ;;
    *) echo "❌ Invalid choice" ;;
esac
