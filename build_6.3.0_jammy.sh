#!/bin/bash

docker run -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:5_jammy \
    /build_qt6.sh 6.3.0 https://download.qt.io/official_releases/qt/6.3/6.3.0/single/
