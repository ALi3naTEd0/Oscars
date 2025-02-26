# Maintainer: Your Name
pkgname=oscars
pkgver=1.2.0
pkgrel=1
pkgdesc="The 97th Academy Awards unofficial app"
arch=('x86_64')
url="https://github.com/yourusername/Oscars"
license=('MIT')
depends=('gtk3' 'xdg-user-dirs')
makedepends=('flutter' 'cmake' 'ninja' 'clang')
source=("$pkgname-$pkgver.tar.gz")
sha256sums=('SKIP')

prepare() {
    cd "$srcdir/$pkgname"
    flutter upgrade
    flutter clean
}

build() {
    cd "$srcdir/$pkgname-$pkgver"
    flutter build linux --release
}

package() {
    cd "$srcdir/$pkgname-$pkgver"
    
    # Binary
    install -Dm755 "build/linux/x64/release/bundle/oscars" "$pkgdir/usr/bin/oscars"
    
    # Desktop file
    install -Dm644 "linux/flutter/packaging/linux/oscars.desktop" "$pkgdir/usr/share/applications/oscars.desktop"
    
    # Icons
    install -Dm644 "assets/oscars.png" "$pkgdir/usr/share/icons/hicolor/512x512/apps/oscars.png"
    
    # License
    install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    
    # Data files
    cp -r "build/linux/x64/release/bundle/data" "$pkgdir/usr/lib/oscars/"
    cp -r "build/linux/x64/release/bundle/lib" "$pkgdir/usr/lib/oscars/"
}

post_install() {
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor
}