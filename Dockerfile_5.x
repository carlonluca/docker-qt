FROM ubuntu:focal
ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /root

ARG TARGETARCH
ARG QTVER

COPY qt_export/Qt-amd64-$QTVER.tar.xz /root/
COPY qt_export/Qt-arm64-$QTVER.tar.xz /root/
COPY qt_export/Qt-android-$QTVER.tar.xz /root/

COPY builder/toolchain.cmake /root/

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
        '^libxcb.*-dev' libxkbcommon-dev libxkbcommon-x11-dev wget libwayland-dev \
        libmd4c-dev && \
    apt -y install flex bison gperf libicu-dev libxslt-dev ruby && \
    apt -y install libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev \
        libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev \
        libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev \
        libegl1-mesa-dev gperf bison nodejs && \
    apt -y install libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev

# Dev tools
RUN apt-get -y install git git-lfs ccache

# Android
ADD https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip /opt/
RUN \
    export DEBIAN_FRONTEND=noninteractive \
 && if [ "$TARGETARCH" != "arm64" ]; then \
    export PATH=$PATH:/opt/cmdline-tools/bin \
 && cd /opt/ \
 && unzip commandlinetools-linux-9477386_latest.zip \
 && rm commandlinetools-linux-9477386_latest.zip \
 && export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
 && apt-get install -y openjdk-11-jdk \
 && yes | sdkmanager --sdk_root=/opt/android-sdk --licenses \
 && sdkmanager --sdk_root=/opt/android-sdk "platforms;android-31" "platform-tools" "build-tools;31.0.0" \
 && export ANDROID_SDK_ROOT=/opt/android-sdk \
 && sdkmanager --sdk_root=/opt/android-sdk --list \
 && sdkmanager --sdk_root=/opt/android-sdk "ndk;21.4.7075529" \
 && export ANDROID_NDK_ROOT=/opt/android-sdk/ndk/21.4.7075529; \
    fi

ENV PATH=$PATH:/opt/cmdline-tools/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_ROOT=/opt/android-sdk/ndk/21.4.7075529

RUN \
    cd /opt && \
    git clone --verbose https://github.com/KDAB/android_openssl /opt/android-openssl && \
    cd /opt/android-openssl && \
    git checkout 8597b4510703ee6c1c9ee25ca771d7b848090102 && \
    cd -

RUN \
    cd /opt && \
    tar xvfp /root/Qt-arm64-$QTVER.tar.xz && \
    rm /root/Qt-arm64-$QTVER.tar.xz

RUN \
    cd /opt && \
    if [ "$TARGETARCH" != "arm64" ]; then \
        tar xvfp /root/Qt-amd64-$QTVER.tar.xz; \
        rm /root/Qt-amd64-$QTVER.tar.xz; \
        tar xvfp /root/Qt-android-$QTVER.tar.xz; \
        rm /root/Qt-android-$QTVER.tar.xz; \
    fi

RUN \
    echo "/opt/Qt-$TARGETARCH-$QTVER/lib" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf \
 && ldconfig

RUN \
    rm -f /root/Qt-amd64-$QTVER.tar.xz \
 && rm -f /root/Qt-arm64-$QTVER.tar.xz \
 && rm -f /root/Qt-android-$QTVER.tar.xz

RUN \
    apt-get -y autoremove \
 && apt-get -y autoclean \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/opt/Qt-$TARGETARCH-$QTVER/bin:/opt/Qt-$TARGETARCH-$QTVER/libexec"
ENV QT_HOST_PATH="/opt/Qt-$TARGETARCH-$QTVER/"
ENV QT_PLUGIN_PATH="/opt/Qt-$TARGETARCH-$QTVER/plugins"
ENV OPENSSL_ROOT_DIR="/opt/android_openssl/ssl_1.1"