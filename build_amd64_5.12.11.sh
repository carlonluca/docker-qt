#!/bin/bash

docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_amd64.sh:/build_amd64.sh carlonluca/qt-builder:focal \
    /build_amd64.sh 5.12.11 https://download.qt.io/official_releases/qt/5.12/5.12.11/single/
