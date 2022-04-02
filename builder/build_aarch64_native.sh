#!/bin/bash

wget --no-check-certificate "https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz"
tar xvfp qt-everywhere-src-5.15.2.tar.xz
mkdir build
cd build
../qt-everywhere-src-5.15.2/configure -opensource -confirm-license -release -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz -prefix /opt/Qt-arm64-5.15.2 -v -pkg-config
make -j $(($(nproc)+4))
make install
cd /opt
tar cvfpJ /root/export/Qt-arm64-5.15.2.tar.xz Qt-arm64-5.15.2
