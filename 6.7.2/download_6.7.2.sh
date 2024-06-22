#!/bin/bash

version=6.7.2

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy-6.7 bash -c '
pip install -U aqtinstall && \
aqt install --outputdir /opt/qt $0 linux desktop linux_gcc_64 \
    -m $(aqt list-qt linux desktop --modules $0 linux_gcc_64 | sed "s/debug_info//") &&
cd /opt &&
ln -s ./qt/$0/gcc_64 Qt-amd64-$0 &&
tar cvfpJ /root/export/Qt-amd64-$0.tar.xz qt Qt-amd64-$0
' $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy-6.7 bash -c '
cd /opt && \
tar xvfp /root/export/Qt-amd64-$0.tar.xz && \
cd && \
git clone --verbose --depth 1 --branch v$0 https://code.qt.io/qt/qt5.git && \
cd qt5 && \
perl init-repository && \
cd .. && \
mkdir build && \
cd build && \
../qt5/configure -zstd -release -nomake examples -nomake tests -skip qtdoc -skip qttools -skip qttranslations -skip qtwebengine -qt-host-path /opt/Qt-amd64-$0 -prefix /opt/Qt-arm64-$0 -- -DCMAKE_TOOLCHAIN_FILE=/root/toolchain.cmake -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=/opt/Qt-arm64-$0 && \
cmake --build . --parallel $(($(nproc)+4)) && \
cmake --install . && \
cp config.summary /opt/Qt-arm64-$0/ && \
cd /opt && \
tar cvfpJ /root/export/Qt-arm64-$0.tar.xz Qt-arm64-$0' $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy-6.7 bash -c '
pip install -U aqtinstall && \
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
