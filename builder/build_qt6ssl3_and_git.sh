#!/bin/bash

set -e

apt-get update
apt-get install -y protobuf-compiler

cd /opt
tar xvfp /root/export/Qt-amd64-$1.tar.xz

cd
git clone https://github.com/KDAB/android_openssl
cd android_openssl
git checkout 82c850c

cd
git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository
cd ..
mkdir build

cd build
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_armv7 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis armeabi-v7a -- -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/armeabi-v7a
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_armv7

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_arm64_v8a -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis arm64-v8a -- -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/arm64-v8a
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_arm64_v8a

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_x86 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis x86 -- -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/x86
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_x86

rm -rf *
../qt5/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_x86_64 -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis x86_64 -- -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/x86_64
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_x86_64

cd /opt
mkdir -p qt
cd qt
mkdir -p $1
cd $1
mv ../../Qt-android-$1/android_armv7 .
mv ../../Qt-android-$1/android_arm64_v8a .
mv ../../Qt-android-$1/android_x86 .
mv ../../Qt-android-$1/android_x86_64 .
cd ../../Qt-android-$1
ln -s ../qt/$1/android_armv7 android_armv7
ln -s ../qt/$1/android_arm64_v8a android_arm64_v8a
ln -s ../qt/$1/android_x86 android_x86
ln -s ../qt/$1/android_x86_64 android_x86_64
cd ..
tar cvfpJ /root/export/Qt-android-$1.tar.xz Qt-android-$1 qt
