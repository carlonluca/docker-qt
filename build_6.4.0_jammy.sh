#!/bin/bash

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_amd64.sh:/build_qt6_amd64.sh carlonluca/qt-builder:jammy \
    /build_qt6_amd64.sh 6.4.0 https://download.qt.io/official_releases/qt/6.4/6.4.0/single/

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_arm64.sh:/build_qt6_arm64.sh carlonluca/qt-builder:jammy \
    /build_qt6_arm64.sh 6.4.0 https://download.qt.io/official_releases/qt/6.4/6.4.0/single/

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6_and.sh:/build_qt6_and.sh carlonluca/qt-builder:jammy \
    /build_qt6_and.sh 6.4.0 https://download.qt.io/official_releases/qt/6.4/6.4.0/single/
