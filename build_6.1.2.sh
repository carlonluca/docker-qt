#!/bin/bash

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:1 \
    /build_qt6.sh 6.1.2 https://download.qt.io/official_releases/qt/6.1/6.1.2/single/
