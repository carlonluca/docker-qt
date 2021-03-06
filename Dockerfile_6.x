FROM ubuntu:20.04
ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /root

ARG TARGETARCH
ARG QTVER

COPY qt_export/Qt-amd64-$QTVER.tar.xz /root/
COPY qt_export/Qt-arm64-$QTVER.tar.xz /root/

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
        '^libxcb.*-dev' libxkbcommon-dev libxkbcommon-x11-dev wget libwayland-dev ninja-build && \
    apt -y install flex bison gperf libicu-dev libxslt-dev ruby && \
    apt -y install libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev \
        libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev \
        libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev \
        libegl1-mesa-dev gperf bison nodejs && \
    apt -y install libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev libcups2-dev \
        libavformat58 libavcodec58 libavutil56 libswresample3 libswscale5 libavdevice58 \
        libmng2 libwebp6 libxcb-xinput0 libwebpmux3 libvpx6 && \
        \
    apt -y autoremove && \
    apt -y autoclean && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    cd /opt && \
    tar xvfp /root/Qt-arm64-$QTVER.tar.xz && \
    rm /root/Qt-arm64-$QTVER.tar.xz

RUN \
    cd /opt && \
    tar xvfp /root/Qt-amd64-$QTVER.tar.xz && \
    rm /root/Qt-amd64-$QTVER.tar.xz


ENV PATH="${PATH}:/opt/Qt-$TARGETARCH-$QTVER/bin"