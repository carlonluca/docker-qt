#!/bin/bash

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:3 \
    /build_qt6.sh 6.2.4 https://download.qt.io/official_releases/qt/6.2/6.2.4/single/
