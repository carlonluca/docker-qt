#!/bin/bash

docker run --rm --name qt-builder -v $PWD/qt_export:/root/export carlonluca/qt-builder:focal /root/build_amd64.sh 5.15.2