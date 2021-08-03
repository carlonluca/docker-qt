FROM ubuntu:focal
ENTRYPOINT [ "/bin/bash" ]

COPY sources.list /etc/apt/sources.list
COPY build_aarch64.sh /root/build_aarch64.sh

RUN chmod +x /root/build_aarch64.sh

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    dpkg --add-architecture arm64 && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential && \
    apt-get -y install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu cmake freeglut3-dev:arm64 gdb git iputils-ping \
    libgl1-mesa-dev:arm64 libglu1-mesa-dev:arm64 libjpeg-dev:arm64 libmysqlclient-dev:arm64 \
    libnss3-dev:arm64 libopus-dev:arm64 libpng-dev:arm64 libsqlite3-dev:arm64 libssl-dev:arm64 \
    libx11-xcb-dev:arm64 libxcb-xinerama0-dev:arm64 libxcb-xkb-dev:arm64 libxcb1-dev:arm64 \
    libxcursor-dev:arm64 libxi-dev:arm64 libxml2-dev:arm64 libxrender-dev:arm64 libxslt-dev:arm64 \
    lzip mesa-common-dev:arm64 nano perl python valgrind wget zlib1g-dev:arm64 '^libxcb.*-dev:arm64' \
    libxkbcommon-dev:arm64 libxkbcommon-x11-dev:arm64 wget libwayland-dev:arm64 flex bison gperf \
    libicu-dev:arm64 libxslt-dev:arm64 ruby libxcursor-dev:arm64 libxcomposite-dev:arm64 \
    libxdamage-dev:arm64 libxrandr-dev:arm64 libxtst-dev:arm64 libxss-dev:arm64 libdbus-1-dev:arm64 \
    libevent-dev:arm64 libfontconfig1-dev:arm64 libcap-dev:arm64 libpulse-dev:arm64 libudev-dev:arm64 \
    libpci-dev:arm64 libnss3-dev:arm64 libasound2-dev:arm64 libegl1-mesa-dev:arm64 gperf bison nodejs \
    libasound2-dev:arm64 libgstreamer1.0-dev:arm64 libgstreamer-plugins-base1.0-dev:arm64 \
    libgstreamer-plugins-good1.0-dev:arm64 g++-aarch64-linux-gnu gcc-aarch64-linux-gnu && \
    \
    apt-get -y install freeglut3-dev libgl1-mesa-dev libglu1-mesa-dev libjpeg-dev libmysqlclient-dev \
    libnss3-dev libopus-dev libpng-dev libsqlite3-dev libssl-dev \
    libx11-xcb-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb1-dev \
    libxcursor-dev libxi-dev libxml2-dev libxrender-dev libxslt-dev mesa-common-dev \
    zlib1g-dev '^libxcb.*-dev' libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev \
    libicu-dev libxslt-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev \
    libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev \
    libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev libasound2-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libnspr4-dev && \
    \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*