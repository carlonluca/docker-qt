#!/bin/bash

set -e

git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..

mkdir build

cd build
../qt5/configure -release -nomake examples -nomake tests -zstd -webengine-proprietary-codecs -prefix /opt/qt/$1/gcc_64
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$1/gcc_64

cd /opt
ln -s /opt/qt/$1/gcc_64 /opt/Qt-amd64-$1
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz Qt-amd64-$1 qt