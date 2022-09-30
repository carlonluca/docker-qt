#!/bin/bash

docker run -it --rm --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:jammy \
    /build_qt6.sh 6.4.0 https://download.qt.io/official_releases/qt/6.4/6.4.0/single/
