# Maintainer: ALi3naTEd0 <ALi3naTEd0@protonmail.com>
pkgname=oscars
pkgver=1.0.0
pkgrel=1
pkgdesc="Aplicación para gestión de premios Oscar"
arch=('x86_64')
url="https://github.com/ALi3naTEd0/oscars"
license=('GPL3')
depends=(
    'gtk3'
    'libglvnd'
    'pcre2'
    'openssl'
    'libayatana-appindicator'
    'libsecret'
)
makedepends=(
    'git'
    'flutter'
    'clang'
    'cmake'
    'ninja'
    'patchelf'
)
source=("git+$url.git")
sha256sums=('SKIP')

build() {
    cd "$srcdir/oscars"
    
    # Compilación con plugins
    flutter clean
    flutter pub get
    flutter build linux --release --dart-define=CI=true
}

package() {
    # Directorio de instalación principal
    INSTALL_DIR="$pkgdir/usr/lib/oscars"
    install -d "$INSTALL_DIR"

    # Copiar todo el bundle incluyendo plugins
    cp -r "$srcdir/oscars/build/linux/x64/release/bundle/"* "$INSTALL_DIR"

    # Enlace simbólico ejecutable
    install -d "$pkgdir/usr/bin"
    ln -s /usr/lib/oscars/oscars "$pkgdir/usr/bin/oscars"

    # Ajustar RPATH para todas las bibliotecas
    find "$INSTALL_DIR/lib" -name '*.so' -exec patchelf --set-rpath '$ORIGIN' {} \;
    patchelf --set-rpath '/usr/lib/oscars/lib' "$INSTALL_DIR/oscars"

    # Archivos adicionales
    install -Dm644 "$srcdir/oscars/linux/runner/oscars.desktop" \
        "$pkgdir/usr/share/applications/oscars.desktop"
    install -Dm644 "$srcdir/oscars/assets/oscars.png" \
        "$pkgdir/usr/share/icons/hicolor/512x512/apps/oscars.png"
}