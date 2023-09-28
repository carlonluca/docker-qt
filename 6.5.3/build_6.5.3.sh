#!/bin/bash

version=6.5.3

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6_amd64_git.sh:/build_qt6_amd64.sh carlonluca/qt-builder:jammy \
    /build_qt6_amd64.sh $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export carlonluca/qt-builder:jammy bash -c '
cd /opt && \
tar xvfp /root/export/Qt-amd64-$0.tar.xz && \
cd && \
git clone --verbose --depth 1 --branch v$0 https://code.qt.io/qt/qt5.git && \
cd qt5 && \
perl init-repository && \
cd .. && \
mkdir build && \
cd build && \
../qt5/configure -no-zstd -release -nomake examples -nomake tests -skip qtdoc -skip qttools -skip qttranslations -skip qtwebengine -qt-host-path /opt/Qt-amd64-$0 -prefix /opt/Qt-arm64-$0 -- -DCMAKE_TOOLCHAIN_FILE=/root/toolchain.cmake -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=/opt/Qt-arm64-$0 && \
cmake --build . --parallel $(($(nproc)+4)) && \
cmake --install . && \
cp config.summary /opt/Qt-arm64-$0/ && \
cd /opt && \
tar cvfpJ /root/export/Qt-arm64-$0.tar.xz Qt-arm64-$0' $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6ssl3_and_git.sh:/build_qt6_and.sh carlonluca/qt-builder:jammy \
    /build_qt6_and.sh $version
