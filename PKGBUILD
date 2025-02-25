# Maintainer: ALi3naTEd0
pkgname=oscars
pkgver=1.0.1
pkgrel=1
pkgdesc="The 97th Academy Awards app"
arch=('x86_64')
url="https://github.com/ALi3naTEd0/Oscars"
license=('MIT')
depends=('gtk3' 'libsecret')
makedepends=('flutter')

# For local builds, use the local source
if [ -z "$CI" ]; then
    source=("$pkgname::git+file://$PWD")
else
    # In CI, use the GitHub repo
    source=("$pkgname::git+$url.git")
fi

sha256sums=('SKIP')

build() {
    cd "$srcdir/$pkgname"
    flutter pub get
    flutter build linux --release
}

package() {
    cd "$srcdir/$pkgname"
    
    # Install binary
    install -Dm755 "build/linux/x64/release/bundle/$pkgname" "$pkgdir/usr/bin/$pkgname"
    
    # Install desktop and icon files - using absolute paths
    install -Dm644 "${startdir}/desktop/$pkgname.desktop" "$pkgdir/usr/share/applications/$pkgname.desktop"
    install -Dm644 "${startdir}/assets/app-icon.png" "$pkgdir/usr/share/pixmaps/$pkgname.png"
}