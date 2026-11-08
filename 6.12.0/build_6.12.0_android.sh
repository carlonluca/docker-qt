#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    2026.10.03
#

qt_version="6.12.0"
qt_src="qt-src"
ffmpeg_version="9.0.1"

podman run -it --rm --name qt-builder2 \
    -v $PWD/../qt_export:/root/export \
    -v "$qt_src":/qt \
    docker.io/carlonluca/qt-builder:resolute-21-36-27.2.12479018 \
    bash -c '

set -e

export qt_version="$0"
export ffmpeg_version="$1"
export ANDROID_SDK_HOME=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT

cd
git clone https://github.com/carlonluca/ffmpeg-android-maker.git
cd ffmpeg-android-maker
git checkout qt
./ffmpeg-android-maker.sh --disable-shared --enable-static --source-git-tag=n$ffmpeg_version

mkdir -p /opt/qt/$qt_version
cd /opt/qt/$qt_version
tar xvfp /root/export/Qt-amd64-$qt_version.tar.xz

cd
git clone https://github.com/KDAB/android_openssl
cd android_openssl
git checkout 82c850c

cd /qt
if [ ! -d /qt/qt5 ]; then
    git clone https://code.qt.io/qt/qt5.git
    cd qt5
    perl init-repository
    cd ..
fi

cd /qt/qt5
git fetch
git submodule foreach --recursive git fetch
git checkout v$qt_version
git submodule sync --recursive
git submodule deinit -f --all
git submodule update --init --recursive
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf

cd
mkdir build

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/armeabi-v7a
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/armeabi-v7a
export PKG_CONFIG_PATH="$FFMPEG_LIB_DIR/pkgconfig"
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -skip qtpdf \
    -prefix /opt/qt/$qt_version/android_armv7 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis armeabi-v7a -- \
    -DQT_ALLOW_DOWNLOAD=ON \
    -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include \
    -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/armeabi-v7a \
    -DFFMPEG_LIBRARIES=$FFMPEG_LIB_DIR \
    -DFFMPEG_INCLUDE_DIRS=$FFMPEG_INC_DIR \
    -DAVCODEC_LIBRARY=$FFMPEG_LIB_DIR/libavcodec.a \
    -DAVFORMAT_LIBRARY=$FFMPEG_LIB_DIR/libavformat.a \
    -DAVUTIL_LIBRARY=$FFMPEG_LIB_DIR/libavutil.a \
    -DSWRESAMPLE_LIBRARY=$FFMPEG_LIB_DIR/libswresample.a \
    -DSWSCALE_LIBRARY=$FFMPEG_LIB_DIR/libswscale.a \
    -DAVCODEC_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVFORMAT_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVUTIL_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWRESAMPLE_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWSCALE_INCLUDE_DIR=$FFMPEG_INC_DIR
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$qt_version/android_armv7

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/arm64-v8a
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/arm64-v8a
export PKG_CONFIG_PATH="$FFMPEG_LIB_DIR/pkgconfig"
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -skip qtpdf \
    -prefix /opt/qt/$qt_version/android_arm64_v8a \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis arm64-v8a -- \
    -DQT_ALLOW_DOWNLOAD=ON \
    -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include \
    -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/arm64-v8a \
    -DFFMPEG_LIBRARIES=$FFMPEG_LIB_DIR \
    -DFFMPEG_INCLUDE_DIRS=$FFMPEG_INC_DIR \
    -DAVCODEC_LIBRARY=$FFMPEG_LIB_DIR/libavcodec.a \
    -DAVFORMAT_LIBRARY=$FFMPEG_LIB_DIR/libavformat.a \
    -DAVUTIL_LIBRARY=$FFMPEG_LIB_DIR/libavutil.a \
    -DSWRESAMPLE_LIBRARY=$FFMPEG_LIB_DIR/libswresample.a \
    -DSWSCALE_LIBRARY=$FFMPEG_LIB_DIR/libswscale.a \
    -DAVCODEC_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVFORMAT_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVUTIL_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWRESAMPLE_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWSCALE_INCLUDE_DIR=$FFMPEG_INC_DIR
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$qt_version/android_arm64_v8a

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/x86
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/x86
export PKG_CONFIG_PATH="$FFMPEG_LIB_DIR/pkgconfig"
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -skip qtpdf -platform android-clang \
    -prefix /opt/qt/$qt_version/android_x86 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis x86 -- \
    -DQT_ALLOW_DOWNLOAD=ON \
    -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include \
    -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/x86 \
    -DFFMPEG_LIBRARIES=$FFMPEG_LIB_DIR \
    -DFFMPEG_INCLUDE_DIRS=$FFMPEG_INC_DIR \
    -DAVCODEC_LIBRARY=$FFMPEG_LIB_DIR/libavcodec.a \
    -DAVFORMAT_LIBRARY=$FFMPEG_LIB_DIR/libavformat.a \
    -DAVUTIL_LIBRARY=$FFMPEG_LIB_DIR/libavutil.a \
    -DSWRESAMPLE_LIBRARY=$FFMPEG_LIB_DIR/libswresample.a \
    -DSWSCALE_LIBRARY=$FFMPEG_LIB_DIR/libswscale.a \
    -DAVCODEC_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVFORMAT_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVUTIL_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWRESAMPLE_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWSCALE_INCLUDE_DIR=$FFMPEG_INC_DIR
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$qt_version/android_x86

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/x86_64
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/x86_64
export PKG_CONFIG_PATH="$FFMPEG_LIB_DIR/pkgconfig"
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -skip qtpdf -platform android-clang \
    -prefix /opt/qt/$qt_version/android_x86_64 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis x86_64 -- \
    -DQT_ALLOW_DOWNLOAD=ON \
    -DOPENSSL_INCLUDE_DIR=/root/android_openssl/ssl_3/include \
    -DOPENSSL_LIBRARIES=/root/android_openssl/ssl_3/x86_64 \
    -DFFMPEG_LIBRARIES=$FFMPEG_LIB_DIR \
    -DFFMPEG_INCLUDE_DIRS=$FFMPEG_INC_DIR \
    -DAVCODEC_LIBRARY=$FFMPEG_LIB_DIR/libavcodec.a \
    -DAVFORMAT_LIBRARY=$FFMPEG_LIB_DIR/libavformat.a \
    -DAVUTIL_LIBRARY=$FFMPEG_LIB_DIR/libavutil.a \
    -DSWRESAMPLE_LIBRARY=$FFMPEG_LIB_DIR/libswresample.a \
    -DSWSCALE_LIBRARY=$FFMPEG_LIB_DIR/libswscale.a \
    -DAVCODEC_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVFORMAT_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DAVUTIL_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWRESAMPLE_INCLUDE_DIR=$FFMPEG_INC_DIR \
    -DSWSCALE_INCLUDE_DIR=$FFMPEG_INC_DIR
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/qt/$qt_version/android_x86_64

cd /opt/qt/$qt_version

tar cvfpJ /root/export/Qt-android-$qt_version.tar.xz android_x86_64 android_x86 android_arm64_v8a android_armv7
' $qt_version $ffmpeg_version
