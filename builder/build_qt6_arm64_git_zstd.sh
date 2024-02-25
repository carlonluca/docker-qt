#!/bin/bash

set -e

cd /opt
tar xvfp /root/export/Qt-amd64-$1.tar.xz

cd
git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..
mkdir build

cd build
../qt5/configure -zstd -release -nomake examples -nomake tests -skip qtwebengine -qt-host-path /opt/Qt-amd64-$1 -prefix /opt/Qt-arm64-$1 -- -DCMAKE_TOOLCHAIN_FILE=/root/toolchain.cmake -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=/opt/Qt-arm64-$1
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-arm64-$1/

cd /opt
tar cvfpJ /root/export/Qt-arm64-$1.tar.xz Qt-arm64-$1