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
    'libayatana-appindicator'  # Necesario para algunos plugins
)
makedepends=(
    'git'
    'flutter'
    'clang'
    'cmake'
    'ninja'
    'patchelf'  # Requerido para ajustar las dependencias
)
source=("git+$url.git")
sha256sums=('SKIP')

build() {
    cd "$srcdir/oscars"
    
    # Generar archivo .desktop si no existe
    [ ! -f "linux/runner/oscars.desktop" ] && \
    cat > linux/runner/oscars.desktop <<EOF
[Desktop Entry]
Name=Oscars
Comment=Gestión de premios Oscar
Exec=oscars
Icon=oscars
Terminal=false
Type=Application
Categories=Utility;
StartupWMClass=Oscars
EOF

    flutter clean
    flutter pub get
    flutter build linux --release
}

package() {
    # Directorio base de instalación
    INSTALL_DIR="$pkgdir/usr/lib/oscars"
    
    # Copiar todo el bundle
    mkdir -p "$INSTALL_DIR"
    cp -r "$srcdir/oscars/build/linux/x64/release/bundle/"* "$INSTALL_DIR"
    
    # Enlace simbólico al ejecutable
    mkdir -p "$pkgdir/usr/bin"
    ln -s /usr/lib/oscars/oscars "$pkgdir/usr/bin/oscars"

    # Ajustar las bibliotecas con patchelf
    patchelf --set-rpath '/usr/lib/oscars/lib' "$INSTALL_DIR/oscars"

    # Archivo .desktop
    install -Dm644 "$srcdir/oscars/linux/runner/oscars.desktop" \
        "$pkgdir/usr/share/applications/oscars.desktop"

    # Ícono
    install -Dm644 "$srcdir/oscars/linux/runner/resources/oscars.png" \
        "$pkgdir/usr/share/icons/hicolor/512x512/apps/oscars.png"
}