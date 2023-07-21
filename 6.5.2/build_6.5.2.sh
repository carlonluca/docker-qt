#!/bin/bash

version=6.5.2

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6_amd64_git.sh:/build_qt6_amd64.sh carlonluca/qt-builder:jammy \
    /build_qt6_amd64.sh $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6_arm64_git.sh:/build_qt6_arm64.sh carlonluca/qt-builder:jammy \
    /build_qt6_arm64.sh $version

docker run -it --rm --name qt-builder -v $PWD/../qt_export:/root/export \
    -v $(pwd)/../builder/build_qt6ssl3_and_git.sh:/build_qt6_and.sh carlonluca/qt-builder:jammy \
    /build_qt6_and.sh $version
