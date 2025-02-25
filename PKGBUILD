# Maintainer: ALi3naTEd0
pkgname=(oscars{,-dbg})  # Split package with debug
pkgver=1.0.1
pkgrel=1
pkgdesc="The 97th Academy Awards app"
arch=('x86_64')
url="https://github.com/ALi3naTEd0/Oscars"
license=('MIT')
makedepends=('flutter' 'gtk3' 'libsecret')

# For local builds, use the local source
if [ -z "$CI" ]; then
    source=("oscars::git+file://$PWD")
else
    source=("oscars::git+$url.git")
fi

sha256sums=('SKIP')

build() {
    cd "$srcdir/oscars"
    flutter pub get
    flutter build linux --release
}

package_oscars() {
    depends=('gtk3' 'libsecret')
    cd "$srcdir/oscars"
    
    # Create directories
    mkdir -p "$pkgdir/usr/lib/$pkgname"
    mkdir -p "$pkgdir/usr/bin"
    mkdir -p "$pkgdir/usr/share/applications"
    mkdir -p "$pkgdir/usr/share/pixmaps"

    # Install app files
    cp -r build/linux/x64/release/bundle/* "$pkgdir/usr/lib/$pkgname/"

    # Create launcher
    echo '#!/bin/sh' > "$pkgdir/usr/bin/$pkgname"
    echo "cd /usr/lib/$pkgname && ./$pkgname" >> "$pkgdir/usr/bin/$pkgname"
    chmod 755 "$pkgdir/usr/bin/$pkgname"
    
    # Install desktop files
    install -Dm644 "desktop/$pkgname.desktop" "$pkgdir/usr/share/applications/$pkgname.desktop"
    install -Dm644 "assets/app-icon.png" "$pkgdir/usr/share/pixmaps/$pkgname.png"
}

package_oscars-dbg() {
    pkgdesc="Debug symbols for Oscars"
    depends=(oscars)
    provides=(oscars-debug)
    conflicts=(oscars-debug)
    options=('!strip')

    cd "$srcdir/oscars"
    
    # Create debug directory
    mkdir -p "$pkgdir/usr/lib/debug/oscars"
    
    # Copy debug files
    find build/linux/x64/release/bundle -type f -executable | while read -r f; do
        if [ -f "$f" ]; then
            dest="$pkgdir/usr/lib/debug/oscars/$(basename "$f").debug"
            objcopy --only-keep-debug "$f" "$dest"
        fi
    done
}