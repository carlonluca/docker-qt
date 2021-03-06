#!/bin/bash

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:2 \
    /build_qt6.sh 6.2.0 https://download.qt.io/official_releases/qt/6.2/6.2.0/single/
