#!/bin/bash

set -e

git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..

mkdir build

cd build
../qt5/configure -release -nomake examples -nomake tests -zstd -webengine-proprietary-codecs -prefix /opt/Qt-amd64-$1
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-amd64-$1/

cd /opt
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz Qt-amd64-$1
