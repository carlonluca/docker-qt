#!/bin/bash

version=6.4.3

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy bash -c '
aqt install --outputdir /opt/qt 6.4.3 linux desktop gcc_64 \
    -m qt3d qt5compat qtcharts qtconnectivity qtdatavis3d qthttpserver qtimageformats qtlanguageserver qtlottie qtmultimedia qtnetworkauth qtpdf qtpositioning qtquick3d qtquick3dphysics qtquicktimeline qtremoteobjects qtscxml qtsensors qtserialbus \
       qtserialport qtshadertools qtspeech qtvirtualkeyboard qtwaylandcompositor qtwebchannel qtwebengine qtwebsockets qtwebview &&
mv /opt/qt/6.4.3/gcc_64 /opt/Qt-amd64-6.4.3 &&
cd /opt &&
ln -s qt/6.4.3/gcc_64 Qt-amd64-6.4.3 &&
tar cvfpJ /root/export/Qt-amd64-6.4.3.tar.xz qt Qt-amd64-6.4.3
'

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6_arm64_git.sh:/build_qt6_arm64.sh carlonluca/qt-builder:jammy \
    /build_qt6_arm64.sh $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy bash -c '
for arch in android_armv7 android_arm64_v8a android_x86_64 android_x86; do \
    aqt install-qt --outputdir /opt/qt linux android 6.4.3 $arch \
        -m $(aqt list-qt linux android --modules 6.4.3 $arch); \
done && \
cd /opt && \
mkdir Qt-android-6.4.3 && \
ln -s qt/6.4.3/android_armv7 Qt-android-6.4.3/android_armv7 &&
ln -s qt/6.4.3/android_arm64_v8a Qt-android-6.4.3/android_arm64_v8a &&
ln -s qt/6.4.3/android_x86 Qt-android-6.4.3/android_x86 &&
ln -s qt/6.4.3/android_x86_64 Qt-android-6.4.3/android_x86_64 &&
tar cvfpJ /root/export/Qt-android-6.4.3.tar.xz Qt-android-6.4.3 qt
'
