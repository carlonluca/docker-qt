#!/bin/bash

set -e

wget --no-check-certificate "$2/qt-everywhere-src-$1.tar.xz"
tar xvfp qt-everywhere-src-$1.tar.xz
mkdir build

cd build
../qt-everywhere-src-$1/configure -release -nomake examples -nomake tests -no-zstd -webengine-proprietary-codecs -prefix /opt/Qt-amd64-$1 -- -DFEATURE_ffmpeg=OFF
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-amd64-$1/

cd /opt
tar cvfpJ /root/export/Qt-amd64-$1.tar.xz Qt-amd64-$1