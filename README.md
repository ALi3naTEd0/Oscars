<img src="assets/oscars.png" width="200">

# The 97th Academy Awards

![Version](https://img.shields.io/badge/version-1.0.0--1-blue)
![License](https://img.shields.io/badge/license-GPL--3.0-green)
![Downloads](https://img.shields.io/github/downloads/ALi3naTEd0/oscars/total)
![Last Commit](https://img.shields.io/github/last-commit/ALi3naTEd0/oscars)
![Stars](https://img.shields.io/github/stars/ALi3naTEd0/oscars)

[Discord](https://discordapp.com/channels/@me/343448030986371072/)

## Table of Contents
- [Introduction](#introduction)
- [Screenshots](#screenshots)
- [Downloads](#downloads)
- [Installation](#installation)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Project Architecture](#project-architecture)
- [Development](#development)
- [License](#license)
- [Contact](#contact)

## Introduction

Welcome to **The 97th Academy Awards** app, your digital companion for exploring Oscar-nominated movies. Browse through nominations, view movie details, check IMDb ratings, and access direct links to IMDb pages - all in one place.
<!---
## Screenshots
Coming soon...
--->
## Downloads
| Windows      | MacOS        | Linux        | Android      | iOS          |
|--------------|--------------|--------------|--------------|--------------|
| [Installer](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.0.0/oscars_1.0.0-1_setup.exe)    | [DMG](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.0.0/oscars_1.0.0-1.dmg)  | [DEB](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.0.0/oscars_1.0.0-1_amd64.deb)  | [APK-Universal](https://github.com/ALi3naTEd0/oscars/releases/download/v1.0.0/oscars-release.apk)       | Maybe?       |
| [Portable](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.0.0/oscars_1.0.0-1_portable.zip)     |              | [RPM](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.0.0/oscars_1.0.0-1_x86_64.rpm)  | [APK-arm64-v8a](https://github.com/ALi3naTEd0/oscars/releases/download/v1.0.0/oscars-arm64-v8a-release.apk)             |              |
|              |              | [Arch](#arch-linux)  | [APK-armeabi-v7a](https://github.com/ALi3naTEd0/oscars/releases/download/v1.0.0/oscars-armeabi-v7a-release.apk)      |              |
|              |              | [AppImage](#appimage)  | [APK-x86_64](https://github.com/ALi3naTEd0/oscars/releases/download/v1.0.0/oscars-x86_64-release.apk)               |              |

## Installation

### Windows
1. Installer: Run `oscars_1.0.0-1_setup.exe` and follow the installation wizard
   - Or -
2. Portable: Extract `oscars_1.0.0-1_portable.zip` and run `oscars.exe`

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
1. Download `oscars_1.0.0-1.dmg`
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
chmod +x oscars_1.0.0-1.AppImage
```
3. Run:
```bash
./oscars_1.0.0-1.AppImage
```

#### DEB Package (Ubuntu/Debian)
```bash
sudo apt install ./oscars_1.0.0-1_amd64.deb
```

#### RPM Package (Fedora/RHEL)
```bash
sudo rpm -i oscars_1.0.0-1_x86_64.rpm
```

#### Arch Linux
```bash
git clone https://github.com/ALi3naTEd0/Oscars.git
cd Oscars
makepkg -si
```

## Features
- 🎬 Browse Oscar nominated movies
- ⭐ View IMDb ratings and details
- 🔗 Direct links to IMDb pages
- 🎲 Random movie selection
- 🖼️ Movie poster visualization
- 💾 Cached images for faster loading

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

## License
This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE) file for details.

## Contact
[Discord](https://discordapp.com/channels/@me/343448030986371072/)

Project Link: [https://github.com/ALi3naTEd0/Oscars](https://github.com/ALi3naTEd0/Oscars)

---
Developed with ♥ by [X](https://github.com/ALi3naTEd0)
