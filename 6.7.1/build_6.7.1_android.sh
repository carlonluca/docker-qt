#!/bin/bash

qt_version="6.7.1"
ffmpeg_version="6.1.1"

docker run -it --rm --name qt-builder2 -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy-6.7 bash -c '
#!/bin/bash
set -e

export qt_version="$0"
export ffmpeg_version="$1"
export ANDROID_SDK_HOME=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT

apt-get update
apt-get install -y protobuf-compiler curl

cd
git clone https://github.com/carlonluca/ffmpeg-android-maker.git
cd ffmpeg-android-maker
git checkout qt
./ffmpeg-android-maker.sh --disable-shared --enable-static --source-git-tag=n$ffmpeg_version

cd /opt
tar xvfp /root/export/Qt-amd64-$qt_version.tar.xz

cd
git clone https://github.com/KDAB/android_openssl
cd android_openssl
git checkout 82c850c

cd
git clone --verbose --depth 1 --branch v$qt_version https://code.qt.io/qt/qt5.git
cd qt5
perl init-repository



cd
mkdir build

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/armeabi-v7a
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/armeabi-v7a
cd
cd build
rm -rf *
../qt5/configure -verbose -release -nomake examples -nomake tests -platform android-clang \
    -prefix /opt/Qt-android-$qt_version/android_armv7 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/Qt-amd64-$qt_version \
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
cp config.summary /opt/Qt-android-$qt_version/android_armv7

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/arm64-v8a
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/arm64-v8a
cd
cd build
rm -rf *
../qt5/configure -verbose -release -nomake examples -nomake tests -platform android-clang \
    -prefix /opt/Qt-android-$qt_version/android_arm64_v8a \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/Qt-amd64-$qt_version \
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
cp config.summary /opt/Qt-android-$qt_version/android_arm64_v8a

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/x86
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/x86
cd
cd build
rm -rf *
../qt5/configure -verbose -release -nomake examples -nomake tests -platform android-clang \
    -prefix /opt/Qt-android-$qt_version/android_x86 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/Qt-amd64-$qt_version \
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
cp config.summary /opt/Qt-android-$qt_version/android_x86

export FFMPEG_LIB_DIR=/root/ffmpeg-android-maker/output/lib/x86_64
export FFMPEG_INC_DIR=/root/ffmpeg-android-maker/output/include/x86_64
cd
cd build
rm -rf *
../qt5/configure -verbose -release -nomake examples -nomake tests -platform android-clang \
    -prefix /opt/Qt-android-$qt_version/android_x86_64 \
    -android-ndk $ANDROID_NDK_ROOT \
    -android-sdk $ANDROID_SDK_ROOT \
    -qt-host-path /opt/Qt-amd64-$qt_version \
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
cp config.summary /opt/Qt-android-$qt_version/android_x86_64

cd /opt
mkdir -p qt
cd qt
mkdir -p $qt_version
cd $qt_version
mv ../../Qt-android-$qt_version/android_armv7 .
mv ../../Qt-android-$qt_version/android_arm64_v8a .
mv ../../Qt-android-$qt_version/android_x86 .
mv ../../Qt-android-$qt_version/android_x86_64 .
cd ../../Qt-android-$qt_version
ln -s ../qt/$qt_version/android_armv7 android_armv7
ln -s ../qt/$qt_version/android_arm64_v8a android_arm64_v8a
ln -s ../qt/$qt_version/android_x86 android_x86
ln -s ../qt/$qt_version/android_x86_64 android_x86_64
cd ..
tar cvfpJ /root/export/Qt-android-$qt_version.tar.xz Qt-android-$qt_version qt
' $qt_version $ffmpeg_version
