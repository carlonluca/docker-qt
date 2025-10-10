#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    2025.10.05
#

qt_version="6.9.3"
qt_src="qt-src"
ffmpeg_version="7.1.1"

podman run -it --rm --name qt-builder2 \
    -v $PWD/../qt_export:/root/export \
    -v "$qt_src":/qt \
    docker.io/carlonluca/qt-builder:noble-17-35-27.2.12479018 \
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
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf
git submodule update --init --recursive


cd qtmultimedia
patch -p1 << 'EOF'
diff --git a/src/plugins/multimedia/ffmpeg/CMakeLists.txt b/src/plugins/multimedia/ffmpeg/CMakeLists.txt
index 6b2e26d9d..6e21b3836 100644
--- a/src/plugins/multimedia/ffmpeg/CMakeLists.txt
+++ b/src/plugins/multimedia/ffmpeg/CMakeLists.txt
@@ -266,6 +266,8 @@ qt_internal_add_plugin(QFFmpegMediaPlugin
         Qt::MultimediaPrivate
 )
 
+target_link_libraries(QFFmpegMediaPlugin PRIVATE -lz)
+
 if (ANDROID)
     set_property(TARGET QFFmpegMediaPlugin APPEND PROPERTY QT_ANDROID_LIB_DEPENDENCIES
         ${INSTALL_PLUGINSDIR}/multimedia/libplugins_multimedia_ffmpegmediaplugin.so
EOF

cd
mkdir build

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/armeabi-v7a
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/armeabi-v7a
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -platform android-clang \
    -prefix /opt/qt/$qt_version/android_armv7 \
    -skip qtwebengine \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis armeabi-v7a -- \
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
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -platform android-clang \
    -prefix /opt/qt/$qt_version/android_arm64_v8a \
    -skip qtwebengine \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis arm64-v8a -- \
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
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -platform android-clang \
    -prefix /opt/qt/$qt_version/android_x86 \
    -skip qtwebengine \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis x86 -- \
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
cd
cd build
rm -rf *
/qt/qt5/configure -verbose -release -nomake examples -nomake tests -skip qttasktree -platform android-clang \
    -prefix /opt/qt/$qt_version/android_x86_64 \
    -skip qtwebengine \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/qt/$qt_version/gcc_64 \
    -android-abis x86_64 -- \
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
