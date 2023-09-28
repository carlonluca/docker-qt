#!/bin/bash

version=6.5.3

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy bash -c '
aqt install --outputdir /opt/qt $0 linux desktop gcc_64 \
    -m $(aqt list-qt linux desktop --modules $0 gcc_64 | sed "s/debug_info//") &&
cd /opt &&
ln -s ./qt/$0/gcc_64 Qt-amd64-$0 &&
tar cvfpJ /root/export/Qt-amd64-$0.tar.xz qt Qt-amd64-$0
' $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6_arm64_git.sh:/build_qt6_arm64.sh carlonluca/qt-builder:jammy \
    /build_qt6_arm64.sh $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy bash -c '
for arch in android_armv7 android_arm64_v8a android_x86_64 android_x86; do \
    aqt install-qt --outputdir /opt/qt linux android $0 $arch \
        -m $(aqt list-qt linux android --modules $0 $arch); \
done && \
cd /opt && \
mkdir Qt-android-$0 && \
ln -s ../qt/$0/android_armv7 Qt-android-$0/android_armv7 &&
ln -s ../qt/$0/android_arm64_v8a Qt-android-$0/android_arm64_v8a &&
ln -s ../qt/$0/android_x86 Qt-android-$0/android_x86 &&
ln -s ../qt/$0/android_x86_64 Qt-android-$0/android_x86_64 &&
tar cvfpJ /root/export/Qt-android-$0.tar.xz Qt-android-$0 qt
' $version
