#!/bin/bash

#
# Author:  Luca Carlon
# Company: -
# Date:    2025.10.05
#

qt_version=6.9.3
qt_src=qt-src

podman run -it --rm --name qt-builder2 \
    -v "$PWD/../qt_export":/root/export \
    -v "$qt_src":/qt \
    -v "$(pwd)/../builder/build_qt6_amd64_git_zstd_2.sh:/build_qt6_amd64.sh" \
    docker.io/carlonluca/qt-builder:noble-17-35-27.2.12479018 bash -c '

set -e

apt-get update
apt-get install -y ca-certificates curl gnupg

# WebEngine
apt-get install -y llvm-dev libclang-dev clang
apt-get install -y python3-venv python3-full
python3 -m venv ~/qt-build-env
source ~/qt-build-env/bin/activate
pip3 install spdx-tools
pip3 install html5lib

mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=16
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# BUILD
cd /qt
if [ ! -d /qt/qt5 ]; then
    git clone https://code.qt.io/qt/qt5.git
    cd qt5
    perl init-repository
    cd ..
fi

cd /qt/qt5
git fetch
git submodule foreach --recursive git fetch
git checkout v$0
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -dxf
git submodule update --init --recursive

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
cmake --build . --parallel $(($(nproc)+1)) || true
cmake --build . --parallel $(($(nproc)+1))

cmake --install .
cp config.summary /opt/qt/$0/gcc_64

cd /opt/qt/$0
tar cvfpJ /root/export/Qt-amd64-$0.tar.xz gcc_64
' $qt_version
