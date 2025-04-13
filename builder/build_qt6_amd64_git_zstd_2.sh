#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    8.4.2025
#

set -e

cd /qt
if [ ! -d /qt/qt5 ]; then
    git clone https://code.qt.io/qt/qt5.git
    cd qt5
    perl init-repository
    cd ..
fi

cd /qt/qt5
git checkout v$1
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf
git submodule update --init --recursive

cd /
mkdir build
cd build
/qt/qt5/configure -release -nomake examples -nomake tests -zstd -webengine-proprietary-codecs -prefix /opt/qt/$1/gcc_64
cmake --build . --parallel $(($(nproc)+1))
cmake --install .
cp config.summary /opt/qt/$1/gcc_64

cd /opt/qt/$1
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz gcc_64
