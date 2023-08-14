#!/bin/bash

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export carlonluca/qt-builder:focal bash -c '
#!/bin/bash

set -e

version=5.15.10-lts-lgpl

git clone --verbose --depth 1 --branch v$version https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository --module-subset=default,-qtwebengine
cd ..

mkdir build
cd build
../qt5/configure -opensource -confirm-license -release -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz -prefix /opt/Qt-amd64-$version -v -pkg-config
make -j $(($(nproc)+4))
make install
cp config.summary /opt/Qt-amd64-$version/

cd /opt
tar cvfpJ /root/export/Qt-amd64-$version.tar.xz Qt-amd64-$version
'

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export carlonluca/qt-builder:focal bash -c '
#!/bin/bash

set -e

version=5.15.10-lts-lgpl

git clone --verbose --depth 1 --branch v$version https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository --module-subset=default,-qtwebengine
cd ..

mkdir build
cd build
export PKG_CONFIG_PATH=/usr/local/lib/aarch64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
../qt5/configure -opensource -confirm-license -release -skip webengine -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz -prefix /opt/Qt-arm64-$version -xplatform linux-aarch64-gnu-g++ -v -sysroot / -pkg-config
make -j $(($(nproc)+4))
make install
cp config.summary /opt/Qt-arm64-$version

cd /opt
tar cvfpJ /root/export/Qt-arm64-$version.tar.xz Qt-arm64-$version
'

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export carlonluca/qt-builder:focal bash -c '
#!/bin/bash

set -e

version=5.15.10-lts-lgpl

git clone --verbose https://github.com/KDAB/android_openssl /opt/android-openssl
cd /opt/android-openssl
git checkout 8597b4510703ee6c1c9ee25ca771d7b848090102
cd -

git clone --verbose --depth 1 --branch v$version https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository --module-subset=default,-qtwebengine
cd ..

mkdir build
cd build
../qt5/configure -opensource -confirm-license -release -skip webengine -nomake tests -nomake examples -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -no-warnings-are-errors -xplatform android-clang -prefix /opt/Qt-android-$version -disable-rpath -android-ndk-host linux-x86_64 --recheck -openssl-runtime -I /opt/android-openssl/ssl_1.1/include
make -j $(($(nproc)+4))
make install
cp config.summary /opt/Qt-android-$version

cd /opt
tar cvfpJ /root/export/Qt-android-$version.tar.xz Qt-android-$version
'
