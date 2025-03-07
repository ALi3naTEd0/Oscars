<img src="assets/oscars.png" width="200">

# The 97th Academy Awards

![Version](https://img.shields.io/github/v/release/ALi3naTEd0/Oscars)
![License](https://img.shields.io/badge/license-GPL--3.0-green)
![Downloads](https://img.shields.io/github/downloads/ALi3naTEd0/Oscars/total)
![Last Commit](https://img.shields.io/github/last-commit/ALi3naTEd0/oscars)
![Stars](https://img.shields.io/github/stars/ALi3naTEd0/oscars)

[Discord](https://discordapp.com/channels/@me/343448030986371072/)

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Screenshots](#screenshots)
- [Downloads](#downloads)
- [Installation](#installation)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Project Architecture](#project-architecture)
- [Development](#development)
- [Changelog](#changelog)
- [License](#license)
- [Contact](#contact)

## Introduction

Welcome to **The 97th Academy Awards** app, your digital companion for exploring Oscar-nominated movies. Browse through nominations, view movie details, check IMDb ratings, and access direct links to IMDb pages - all in one place.

## Features
- 🎬 Browse Oscar nominated movies
- ⭐ View IMDb ratings and details
- 🔗 Direct links to IMDb pages
- 🎲 Random movie selection
- 🖼️ Movie poster visualization
- 💾 Cached images for faster loading

<!---
## Screenshots
Coming soon...
--->

## Downloads
| Windows      | MacOS        | Linux        | Android      | iOS          |
|--------------|--------------|--------------|--------------|--------------|
| [Installer](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1.exe)    | [DMG](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1.dmg)  | [TAR](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-1.1.0-1.tar.gz)  | [APK-Universal](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-1.1.0-1.apk)       | Maybe?       |
| [Portable](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-portable.zip)     |              | [DEB](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1_amd64.deb)  | [APK-arm64-v8a](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-arm64-v8a-1.1.0-1.apk)             |              |
|              |              | [RPM](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1_x86_64.rpm)  | [APK-armeabi-v7a](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-armeabi-v7a-1.1.0-1.apk)      |              |
|              |              | [Arch](#arch-linux)  | [APK-x86_64](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars-x86_64-1.1.0-1.apk)               |              |
|              |              |  [Flatpak](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1.flatpak)            |                 |                 |
|              |              |  [AppImage](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.1.0-1/oscars_1.1.0-1.AppImage)               |                | 

## Installation

### Windows
1. Installer: Run `oscars_1.1.0-1.exe` and follow the installation wizard
   - Or -
2. Portable: Extract `oscars-portable.zip` and run `oscars.exe`

### Android
1. Choose the correct version:
   - APK-Universal: Works on most devices
   - APK-arm64-v8a: Modern phones (2017+)
   - APK-armeabi-v7a: Older phones
   - APK-x86_64: Some tablets/ChromeOS

2. Installation steps:
   - Download your chosen APK
   - Enable "Install from unknown sources" if prompted
   - Open the APK and follow installation steps

### macOS
1. Download `oscars_1.1.0-1.dmg`
2. Open the DMG file
3. Drag Oscars to Applications
4. First launch:
   - Right-click Oscars in Applications
   - Select "Open"
   - If blocked: System Settings -> Privacy & Security -> "Open Anyway"
   - Click "Open" in final dialog

Note: If you see "app is damaged", open Terminal and run:
```bash
xattr -cr /Applications/Oscars.app
```

### Linux

#### AppImage
1. Download the AppImage
2. Make executable:
```bash
chmod +x oscars_1.1.0-1.AppImage
```
3. Run:
```bash
./oscars_1.1.0-1.AppImage
```

#### DEB Package (Ubuntu/Debian)
```bash
sudo apt install ./oscars_1.1.0-1_amd64.deb
```

#### RPM Package (Fedora/RHEL)
```bash
sudo rpm -i oscars_1.1.0-1_x86_64.rpm
```

#### Flatpak
1. Download the Flatpak package
2. Install with:
```bash
flatpak install --user oscars_1.1.0-1.flatpak
```
3. Run:
```bash
flatpak run com.ali3nated0.oscars
```
4. The application will appear in your desktop environment's app launcher with the proper icon and category

#### Arch Linux
```bash
git clone https://github.com/ALi3naTEd0/Oscars.git
cd Oscars
makepkg -si
```

#### TAR Archive (Portable)
1. Download and extract the TAR archive:
```bash
mkdir -p ~/oscars-app
tar -xzf oscars_1.1.0-1.tar.gz -C ~/oscars-app
cd ~/oscars-app
```
2. Run directly from the extracted directory:
```bash
./oscars
```
3. Optional - create a desktop shortcut:
```bash
mkdir -p ~/.local/bin
cp oscars ~/.local/bin/
echo "[Desktop Entry]
Name=Oscars
Exec=~/.local/bin/oscars
Icon=video-display
Type=Application
Categories=Entertainment;" > ~/.local/share/applications/oscars.desktop
```

## Technologies Used
- [Flutter](https://flutter.dev/): Cross-platform UI development
- [Dart](https://dart.dev/): Programming language
- [IMDb API](https://imdb-api.com/): Movie data and ratings
- HTTP Client: API requests and data fetching

## Project Architecture
- **MoviesApp**: Main widget handling state
- **MovieList**: Movie browsing interface
- **MovieDetail**: Detailed movie information
- **CachedImages**: Image loading and caching
- **URLHandler**: External link management

## Development
1. Clone the repository:
```bash
git clone https://github.com/ALi3naTEd0/Oscars.git
cd Oscars
```
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

## Changelog

### [1.1.0] - 2024-03-14
#### Added
- Share functionality for movie details
- Improved button designs with more intuitive layout
- Better user data persistence

#### Fixed
- Render issues with hidden widgets
- Various UI layout improvements

### [1.0.1] - 2024-03-13
#### Added
- Initial release
- Basic movie browsing functionality
- IMDb data integration
- Rating system
- Watch status tracking

## License
This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE) file for details.

## Contact
[Discord](https://discordapp.com/channels/@me/343448030986371072/)

Project Link: [https://github.com/ALi3naTEd0/Oscars](https://github.com/ALi3naTEd0/Oscars)

---
Developed with ♥ by [X](https://github.com/ALi3naTEd0)
