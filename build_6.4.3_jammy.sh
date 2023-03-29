#!/bin/bash

version=6.4.3

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_amd64_git.sh:/build_qt6_amd64.sh carlonluca/qt-builder:jammy \
    /build_qt6_amd64.sh $version https://download.qt.io/official_releases/qt/6.4/$version/single/

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_arm64_git.sh:/build_qt6_arm64.sh carlonluca/qt-builder:jammy \
    /build_qt6_arm64.sh $version https://download.qt.io/official_releases/qt/6.4/$version/single/

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_and_git.sh:/build_qt6_and.sh carlonluca/qt-builder:jammy \
    /build_qt6_and.sh $version https://download.qt.io/official_releases/qt/6.4/$version/single/
