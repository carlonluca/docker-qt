#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    8.4.2025
#

qt_version=6.8.3
qt_src=qt-src

docker run -it --rm --name qt-builder \
    -v $PWD/../qt_export:/root/export \
    -v "$qt_src":/qt \
    carlonluca/qt-builder:noble-17-34-26.1.10909125 bash -c '
mkdir -p /opt/qt/$0 && \
cd /opt/qt/$0 && \
tar xvfp /root/export/Qt-amd64-$0.tar.xz && \

cd /qt && \
if [ ! -d /qt/qt5 ]; then
    git clone https://code.qt.io/qt/qt5.git && \
    cd qt5 && \
    perl init-repository && \
    cd ..;
fi && \

cd /qt/qt5 && \
git checkout v$0 && \
git submodule update --init --recursive && \

cd / && \
mkdir build && \
cd build && \
/qt/qt5/configure \
    -zstd \
    -release \
    -nomake examples \
    -nomake tests \
    -skip qtwebengine \
    -qt-host-path /opt/qt/$0/gcc_64 \
    -prefix /opt/qt/$0/gcc_arm64 -- \
    -DCMAKE_TOOLCHAIN_FILE=/root/toolchain.cmake \
    -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=/opt/qt/$0/gcc_arm64 && \
cmake --build . --parallel $(($(nproc)+4)) && \
cmake --install . && \
cp config.summary /opt/qt/$0/gcc_64/ && \
cd /opt/qt/$0 && \
tar cvfpJ /root/export/Qt-arm64-$0.tar.xz gcc_arm64
' $qt_version