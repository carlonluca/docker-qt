FROM ubuntu:20.04
ENTRYPOINT ["/bin/bash"]

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt -y update && \
    apt -y upgrade && \
    apt -y install \
        build-essential cmake freeglut3-dev gdb git iputils-ping libgl1-mesa-dev \
        libglu1-mesa-dev libjpeg-dev libmysqlclient-dev libnss3-dev libopus-dev \
        libpng-dev libsqlite3-dev libssl-dev libx11-xcb-dev libxcb-xinerama0-dev \
        libxcb-xkb-dev libxcb1-dev libxcursor-dev libxi-dev libxml2-dev libxrender-dev \
        libxslt-dev lzip mesa-common-dev nano perl python valgrind wget zlib1g-dev \
        '^libxcb.*-dev' libxkbcommon-dev libxkbcommon-x11-dev wget libwayland-dev && \
    apt -y install flex bison gperf libicu-dev libxslt-dev ruby && \
    apt -y install libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev \
        libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev \
        libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev \
        libegl1-mesa-dev gperf bison nodejs && \
    apt -y install libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev && \
    apt -y autoremove && \
    apt -y autoclean && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    set -eux && \
    cd /opt && \
    wget --no-check-certificate -q http://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz && \
    tar xf qt-everywhere-src-5.15.2.tar.xz && \
    rm qt-everywhere-src-5.15.2.tar.xz

RUN \
    cd /opt/qt-everywhere-src-5.15.2 && \
    ./configure -opensource -confirm-license -release -nomake tests -nomake examples \
    -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-freetype -qt-pcre -qt-harfbuzz && \
    make -j $(($(nproc)+4)) && \
    make install && \
    cd /opt && \
    rm -rf qt-everywhere-src-5.15.2 && \
    exit 0

ENV PATH="${PATH}:/usr/local/Qt-5.15.2/bin"