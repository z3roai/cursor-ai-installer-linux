A comprehensive, interactive bash script for installing Cursor AI on Linux systems with automatic dependency management and desktop integration.

## 🚀 Features

- **Interactive Installation**: Step-by-step guided installation process
- **Automatic Dependencies**: Installs required packages (libfuse2, desktop-file-utils, curl, wget)
- **Desktop Integration**: Creates desktop launcher and application menu entry
- **SVG Icon**: Downloads and configures the official Cursor SVG icon
- **Flexible Download**: Supports both URL downloads and local AppImage files
- **Root Permissions**: Handles sudo operations automatically
- **Error Handling**: Robust error checking and graceful failure handling

## 📋 Prerequisites

- Linux distribution with `apt` package manager (Ubuntu, Debian, etc.)
- Internet connection for downloading AppImage and dependencies
- Sudo privileges for system-wide installation

## 🛠️ Installation

### Quick Start

1. **Download the installer**:
   ```bash
   wget https://raw.githubusercontent.com/cursor-ai-installer-linux/install-cursor.sh/main/install-cursor.sh
   ```

2. **Make it executable**:
   ```bash
   chmod +x install-cursor.sh
   ```

3. **Run the installer**:
   ```bash
   ./install-cursor.sh
   ```

### Manual Installation

1. Clone or download the `install-cursor.sh` file
2. Make it executable: `chmod +x install-cursor.sh`
3. Run: `./install-cursor.sh`

## 📖 Usage

The installer will guide you through each step interactively:

1. **Download AppImage**: Option to download Cursor from a URL or use a local file
2. **Install Dependencies**: Automatically installs required system packages
3. **Move to /opt**: Places the AppImage in the system directory
4. **Download Icon**: Fetches the official Cursor SVG icon
5. **Create Desktop Entry**: Sets up application launcher
6. **Update Database**: Refreshes the desktop application database

### Interactive Prompts

The script will ask for confirmation at each step:
- `y` or `Y` to proceed
- `n` or `N` to skip
- Any other input will be treated as "no"

## 📁 File Locations

After installation, files are placed in the following locations:

- **AppImage**: `/opt/cursor.appimage`
- **Icon**: `/opt/cursor.svg`
- **Desktop Entry**: `/usr/share/applications/cursor.desktop`

## 🚀 Launching Cursor

After installation, you can launch Cursor AI in several ways:

1. **Application Menu**: Search for "Cursor AI" in your desktop environment
2. **Terminal**: Run `/opt/cursor.appimage --no-sandbox`
3. **Desktop Shortcut**: Click the Cursor icon in your applications menu

## 🔧 Troubleshooting

### Common Issues

1. **Permission Denied**:
   ```bash
   sudo chmod +x install-cursor.sh
   ```

2. **AppImage Not Found**:
   - Ensure the AppImage file exists in `/tmp/` or provide the correct path when prompted

3. **Desktop Entry Not Appearing**:
   ```bash
   sudo update-desktop-database
   ```

4. **Dependencies Missing**:
   ```bash
   sudo apt update && sudo apt install -y libfuse2 desktop-file-utils curl wget
   ```

### Manual Dependency Installation

If the automatic dependency installation fails, manually install:

```bash
sudo apt update
sudo apt install -y libfuse2 desktop-file-utils curl wget
```

## 🗑️ Uninstallation

To remove Cursor AI:

```bash
sudo rm /opt/cursor.appimage
sudo rm /opt/cursor.svg
sudo rm /usr/share/applications/cursor.desktop
sudo update-desktop-database
```

## 📝 Script Details

### What the Script Does

1. **Downloads Cursor AppImage** from a provided URL or uses a local file
2. **Installs system dependencies** required for AppImage execution
3. **Moves the AppImage** to `/opt/` directory for system-wide access
4. **Downloads the official SVG icon** for desktop integration
5. **Creates a desktop entry** for easy application launching
6. **Updates the desktop database** to refresh the application menu

### Safety Features

- Uses `set -e` for error handling
- Confirms each step before execution
- Validates file existence before operations
- Graceful handling of missing files or network issues

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to improve this installer.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Cursor AI team for the excellent IDE
- Linux community for AppImage support
- Contributors and testers

---

**Note**: This installer is designed for Linux distributions using the `apt` package manager. For other distributions, you may need to modify the package installation commands.
