#!/bin/bash

wget --no-check-certificate "$2/qt-everywhere-src-$1.tar.xz"
tar xvfp qt-everywhere-src-$1.tar.xz
mkdir build
cd build
../qt-everywhere-src-$1/configure -opensource -confirm-license -release -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz -prefix /opt/Qt-amd64-$1 -v -pkg-config
make -j $(($(nproc)+4))
make install
cd /opt
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz Qt-amd64-$1