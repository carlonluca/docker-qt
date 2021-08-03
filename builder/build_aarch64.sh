#!/bin/bash

wget --no-check-certificate -q http://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-$1.tar.xz
tar xvfp qt-everywhere-src-$1.tar.xz
mkdir build
cd build
export PKG_CONFIG_PATH=/usr/local/lib/aarch64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
../qt-everywhere-src-5.15.2/configure -opensource -confirm-license -release -skip webengine -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz -prefix /opt/Qt-arm64-$1 -xplatform linux-aarch64-gnu-g++ -v -sysroot / -pkg-config
make -j $(($(nproc)+4))
make install
cd /opt
tar cvfpJ /root/export/Qt-arm64-$1.tar.xz Qt-arm64-$1