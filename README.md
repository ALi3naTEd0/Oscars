<img src="assets/oscars.png" width="200">

# The 98th Academy Awards

![Version](https://img.shields.io/github/v/release/ALi3naTEd0/Oscars)
![License](https://img.shields.io/badge/license-MIT-green)
![Downloads](https://img.shields.io/github/downloads/ALi3naTEd0/Oscars/total)
![Last Commit](https://img.shields.io/github/last-commit/ALi3naTEd0/oscars)
![Stars](https://img.shields.io/github/stars/ALi3naTEd0/oscars)

[Discord](https://discordapp.com/channels/@me/343448030986371072/)

## Table of Contents
[Introduction](#introduction) • 
[Features](#features) • 
[Screenshots](#screenshots) • 
[Downloads](#downloads) • 
[Installation](#installation) • 
[Technologies](#technologies-used) • 
[Getting Started](#getting-started) • 
[Architecture](#project-architecture) • 
[Development](#development) • 
[Changelog](#changelog) • 
[License](#license) • 
[Contact](#contact)

## Introduction

Welcome to **The 98th Academy Awards** app, your digital companion for exploring Oscar-nominated movies. Browse through nominations, view movie details, check IMDb ratings, and access direct links to IMDb pages - all in one place.

## Features
- 🎬 Browse Oscar nominated movies
- ⭐ View IMDb ratings and details
- 🔗 Direct links to IMDb pages
- 🎲 Random movie selection
- 🖼️ Movie poster visualization
- 💾 Cached images for faster loading

## Recent Additions
- Per-year JSON assets for historical ceremonies (assets/oscars_<year>.json). Newly added: 1929, 1930, 1931, 1932, 2023, 2024, 2025, 2026.
- Asset metadata fields: `date`, `ceremonyNumber`, and `imdbEventUrl` to provide canonical ceremony info and links.
- Automated IMDb ID resolver: `tools/fetch_imdb_ids.py --year <YEAR>` populates `imdbIds` in assets and writes a `.imdb.bak` backup.
- `displayNominations` entries now include credited names and movie associations for many categories (e.g., `Music (Original Song)`, `Production Design`).
- Placeholders are added for titles the resolver couldn't match; you can paste `tt` ids directly into `assets/oscars_<year>.json`.
- UI: year selector now displays the year; the app reads per-year metadata from assets to show ceremony details where needed.
 


<!---
## Screenshots
Coming soon...
--->

## Downloads
| Windows      | MacOS        | Linux        | Android      | iOS          |
|--------------|--------------|--------------|--------------|--------------|
| [Installer](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.exe)    | [DMG](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.dmg)  | [TAR](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.tar.gz)  | [APK-Universal](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.apk)       | Maybe?       |
| [Portable](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_portable.zip)     |              | [DEB](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_amd64.deb)  | [APK-arm64-v8a](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_arm64-v8a.apk)             |              |
|              |              | [RPM](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_x86_64.rpm)  | [APK-armeabi-v7a](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_armeabi-v7a.apk)      |              |
|              |              | [Arch](#arch-linux)  | [APK-x86_64](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1_x86_64.apk)               |              |
|              |              |  [Flatpak](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.flatpak)            |                 |                 |
|              |              |  [AppImage](https://github.com/ALi3naTEd0/Oscars/releases/download/v1.3.1-1/oscars_1.3.1-1.AppImage)               |                | 

## Installation

## Years TODO (1929–2026)
The repository maintains per-year assets under `assets/`. Marked years are already present in the repo; unmarked years still need to be added.

<!-- NOTE: keep this list in sync with `assets/` -->

1929 - [x]
1930 - [x]
1931 - [x]
1932 - [x]
1933 - [ ]
1934 - [ ]
1935 - [ ]
1936 - [ ]
1937 - [ ]
1938 - [ ]
1939 - [ ]
1940 - [ ]
1941 - [ ]
1942 - [ ]
1943 - [ ]
1944 - [ ]
1945 - [ ]
1946 - [ ]
1947 - [ ]
1948 - [ ]
1949 - [ ]
1950 - [ ]
1951 - [ ]
1952 - [ ]
1953 - [ ]
1954 - [ ]
1955 - [ ]
1956 - [ ]
1957 - [ ]
1958 - [ ]
1959 - [ ]
1960 - [ ]
1961 - [ ]
1962 - [ ]
1963 - [ ]
1964 - [ ]
1965 - [ ]
1966 - [ ]
1967 - [ ]
1968 - [ ]
1969 - [ ]
1970 - [ ]
1971 - [ ]
1972 - [ ]
1973 - [ ]
1974 - [ ]
1975 - [ ]
1976 - [ ]
1977 - [ ]
1978 - [ ]
1979 - [ ]
1980 - [ ]
1981 - [ ]
1982 - [ ]
1983 - [ ]
1984 - [ ]
1985 - [ ]
1986 - [ ]
1987 - [ ]
1988 - [ ]
1989 - [ ]
1990 - [ ]
1991 - [ ]
1992 - [ ]
1993 - [ ]
1994 - [ ]
1995 - [ ]
1996 - [ ]
1997 - [ ]
1998 - [ ]
1999 - [ ]
2000 - [ ]
2001 - [ ]
2002 - [ ]
2003 - [ ]
2004 - [ ]
2005 - [ ]
2006 - [ ]
2007 - [ ]
2008 - [ ]
2009 - [ ]
2010 - [ ]
2011 - [ ]
2012 - [ ]
2013 - [ ]
2014 - [ ]
2015 - [ ]
2016 - [ ]
2017 - [ ]
2018 - [ ]
2019 - [ ]
2020 - [ ]
2021 - [ ]
2022 - [ ]
2023 - [x]
2024 - [x]
2025 - [x]
2026 - [x]

If you'd like, I can run a script to auto-detect which `assets/oscars_<year>.json` files exist and update this checklist automatically.

### Windows
1. Installer: Run `oscars_1.3.1-1.exe` and follow the installation wizard
   - Or -
2. Portable: Extract `oscars_1.3.1-1_portable.zip` and run `oscars.exe`

### Android
1. Choose the correct version:
   - APK-Universal: Works on most devices
   - APK-arm64-v8a: Modern phones (2017+)
   - APK-armeabi-v7a: Older phones
   - APK-x86_64: Some tablets/ChromeOS

2. Installation:
   - If updating from a previous version: Uninstall it first
   - Download your chosen APK
   - Enable "Install from unknown sources" if prompted (in Settings > Security)
   - Install the new version

### macOS
1. Download `oscars_1.3.1-1.dmg`
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
chmod +x oscars_1.3.1-1.AppImage
```
3. Run:
```bash
./oscars_1.3.1-1.AppImage
```

#### DEB Package (Ubuntu/Debian)
```bash
sudo apt install ./oscars_1.3.1-1_amd64.deb
```

#### RPM Package (Fedora/RHEL)
```bash
sudo rpm -i oscars_1.3.1-1_x86_64.rpm
```

#### Flatpak
1. Download the Flatpak package
2. Install with:
```bash
flatpak install --user oscars_1.3.1-1.flatpak
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
tar -xzf oscars_1.3.1-1.tar.gz -C ~/oscars-app
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
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
[Discord](https://discordapp.com/channels/@me/343448030986371072/)

Project Link: [https://github.com/ALi3naTEd0/Oscars](https://github.com/ALi3naTEd0/Oscars)

---
Developed with ♥ by [X](https://github.com/ALi3naTEd0)
