# Maintainer: ALi3naTEd0
pkgname=oscars
pkgver=1.0.1
pkgrel=1
pkgdesc="The 97th Academy Awards app"
arch=('x86_64')
url="https://github.com/ALi3naTEd0/Oscars"
license=('GPL3')
depends=(
    'gtk3'
    'libsecret'
    'adwaita-icon-theme'
    'libglvnd'
    'pcre2'
    'openssl'
    'hicolor-icon-theme'
    'xcursor-themes'
    'gnome-themes-extra'
)
makedepends=(
    'git'
    'flutter'
    'clang'
    'cmake'
    'ninja'
    'patchelf'
)
options=(!debug)  # Disable debug symbols to avoid conflicts

# Source configuration for local and CI builds
if [ -z "$CI" ]; then
    source=("$pkgname::git+file://$PWD")
else
    source=("$pkgname::git+$url.git")
fi
sha256sums=('SKIP')

prepare() {
    cd "$srcdir/$pkgname"
    flutter upgrade
    flutter clean
}

build() {
    cd "$srcdir/$pkgname"
    flutter config --enable-linux-desktop
    flutter build linux --release
}

package() {
    cd "$srcdir/$pkgname"
    
    # Create required directories
    install -dm755 "$pkgdir/usr/lib/$pkgname"
    install -dm755 "$pkgdir/usr/bin"
    
    # Install bundle files
    cp -r build/linux/x64/release/bundle/* "$pkgdir/usr/lib/$pkgname/"
    
    # Handle plugins if present
    if [ -d "$pkgdir/usr/lib/$pkgname/plugins" ]; then
        cp -r "$pkgdir/usr/lib/$pkgname/plugins/"* "$pkgdir/usr/lib/$pkgname/lib/"
    fi
    
    # Create launcher script with environment setup
    cat > "$pkgdir/usr/bin/$pkgname" << EOF
#!/bin/sh
export GDK_BACKEND=x11
export GTK_THEME=Adwaita
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=24
export LD_LIBRARY_PATH="/usr/lib/$pkgname/lib:\$LD_LIBRARY_PATH"
exec /usr/lib/$pkgname/$pkgname "\$@"
EOF
    chmod 755 "$pkgdir/usr/bin/$pkgname"
    
    # Install desktop and icon files
    install -Dm644 "desktop/$pkgname.desktop" "$pkgdir/usr/share/applications/$pkgname.desktop"
    install -Dm644 "assets/app-icon.png" "$pkgdir/usr/share/icons/hicolor/512x512/apps/$pkgname.png"

    # Fix library paths and RPATH
    find "$pkgdir/usr/lib/$pkgname/lib" -type f -name "*.so" -exec \
        patchelf --set-rpath '/usr/lib/oscars/lib:$ORIGIN' {} \;
    patchelf --set-rpath "/usr/lib/$pkgname/lib" "$pkgdir/usr/lib/$pkgname/$pkgname"
}

post_install() {
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor
}