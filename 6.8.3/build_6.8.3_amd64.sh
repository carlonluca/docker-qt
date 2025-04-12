#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    8.4.2025
#

qt_version=6.8.3
qt_src=qt-src

docker run -it --rm --name qt-builder \
    -v "$PWD/../qt_export":/root/export \
    -v "$qt_src":/qt \
    -v "$(pwd)/../builder/build_qt6_amd64_git_zstd_2.sh:/build_qt6_amd64.sh" \
    carlonluca/qt-builder:noble-17-34-26.1.10909125 bash -c '
apt-get update
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=16
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get purge -y libnode72 nodejs
apt-get install nodejs -y
apt-get install zlib1g-dev libcurl4-openssl-dev -y
/build_qt6_amd64.sh $0
' $qt_version
