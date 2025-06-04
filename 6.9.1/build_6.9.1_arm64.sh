#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    2025.06.03
#

qt_version=6.9.1
qt_src=qt-src

docker run -it --rm --name qt-builder \
    -v $PWD/../qt_export:/root/export \
    -v "$qt_src":/qt \
    carlonluca/qt-builder:noble-17-35-27.2.12479018 bash -c '
export qtversion=$0
mkdir -p /opt/qt/$qtversion
cd /opt/qt/$qtversion
tar xvfp /root/export/Qt-amd64-$qtversion.tar.xz

cd /qt
if [ ! -d /qt/qt5 ]; then
    git clone https://code.qt.io/qt/qt5.git
    cd qt5
    perl init-repository
    cd ..
fi

cd /qt/qt5
git checkout v$qtversion
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf
git submodule update --init --recursive

cd /
mkdir build
cd build
/qt/qt5/configure \
    -zstd \
    -release \
    -nomake examples \
    -nomake tests \
    -skip qtwebengine \
    -qt-host-path /opt/qt/$qtversion/gcc_64 \
    -prefix /opt/qt/$qtversion/gcc_arm64 -- \
    -DCMAKE_TOOLCHAIN_FILE=/root/toolchain.cmake \
    -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=/opt/qt/$qtversion/gcc_arm64
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$qtversion/gcc_64/
cd /opt/qt/$qtversion
tar cvfpJ /root/export/Qt-arm64-$qtversion.tar.xz gcc_arm64
' $qt_version
