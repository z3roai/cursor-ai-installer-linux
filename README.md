# Cursor AI Installer

This is an interactive Bash installer script for installing Cursor AI as an AppImage on Linux systems.  
It allows you to download, install dependencies, move the AppImage to a custom location, set up desktop integration, and more — all step-by-step.

---

## Features

- Selectively run installation steps through a simple menu  
- Specify the full AppImage path (directory + filename) manually  
- Download the AppImage from a URL or use a local file  
- Install required packages (`libfuse2`, etc.) for running AppImages  
- Download and install a SVG icon for desktop integration  
- Create a desktop launcher (.desktop file)  
- Update the desktop database for app menus  
- Create a symlink for easy CLI access (`cursor-ai`)  
- Uninstall all installed components cleanly  

---

## Requirements

- Linux OS with `bash`  
- Sudo/root access for installation steps that modify system files  
- `curl` and `wget` installed (used for downloads)  
- Supported package manager (`apt`, `dnf`, or `pacman`) for installing dependencies  

---

## Usage

1. Run the installer script:

   ```bash
   bash cursor-installer.sh
   ```

2. Choose the step you want to run from the menu.

3. For moving the AppImage, enter the **full path including filename** (e.g., `/opt/cursor.appimage`).

4. Follow prompts for URLs and paths as needed.

5. Once installed, launch Cursor AI via your app menu or from terminal using:

   ```bash
   cursor-ai --no-sandbox
   ```

---

## Uninstall

Run the uninstall option from the menu or execute:

```bash
bash cursor-installer.sh
```

and select the uninstall step to remove installed files and shortcuts.

---

## Troubleshooting

- Ensure you have sufficient permissions (use sudo when required).  
- Verify the URLs and paths you provide are correct and accessible.  
- If desktop entries do not appear immediately, try logging out and back in or running `update-desktop-database` manually.

---

## License

MIT License

---

## Contact

Feel free to open issues or request features on the project repository.

---

Enjoy Cursor AI! 🚀
