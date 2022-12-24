#!/bin/bash

set -e

cd /opt
tar xvfp /root/export/Qt-amd64-$1.tar.xz

cd
wget --no-check-certificate "$2/qt-everywhere-src-$1.tar.xz"
tar xvfp qt-everywhere-src-$1.tar.xz
mkdir build

cd build
../qt-everywhere-src-$1/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-and-armv7a-$1 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis armeabi-v7a
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-and-armv7a-$1

rm -rf *
../qt-everywhere-src-$1/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-and-armv8a-$1 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis arm64-v8a
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-and-armv8a-$1

cd /opt
tar cvfpJ /root/export/Qt-and-armv8a-$1.tar.xz Qt-and-armv8a-$1
tar cvfpJ /root/export/Qt-and-armv7a-$1.tar.xz Qt-and-armv7a-$1