#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    2026.05.19
#

qt_version=6.11.1
qt_src=qt-src

podman run -it --rm --name qt-builder \
    -v "$PWD/../qt_export":/root/export \
    -v "$qt_src":/qt \
    docker.io/carlonluca/qt-builder:noble-21-36-27.2.12479018 bash -c '

set -e

mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=24
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install -y ca-certificates curl gnupg hunspell libhunspell-dev maven nodejs
npm install @openapitools/openapi-generator-cli -g

# WebEngine
apt-get install -y llvm-dev libclang-dev clang doxygen
apt-get install -y python3-venv python3-full
python3 -m venv ~/qt-build-env
source ~/qt-build-env/bin/activate
pip3 install spdx-tools
pip3 install html5lib

# BUILD
cd /qt
if [ ! -d /qt/qt5 ]; then
    git clone https://github.com/qt/qt5.git
    cd qt5
    perl init-repository
    cd ..
fi

cd /qt/qt5
git fetch --tags
git checkout "v$0"
git submodule sync --recursive
git submodule deinit -f --all
git submodule update --init --recursive
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf

cd /
mkdir build
cd build
/qt/qt5/configure \
    -release \
    -nomake examples \
    -nomake tests \
    -skip qttasktree \
    -zstd \
    -webengine-proprietary-codecs \
    -prefix /opt/qt/$0/gcc_64

# WebEngine seems to fail the first time
cmake --build . --parallel $(($(nproc)+1))

cmake --install .
cp config.summary /opt/qt/$0/gcc_64

cd /opt/qt/$0
tar cvfpJ /root/export/Qt-amd64-$0.tar.xz gcc_64
' $qt_version
