# Intro

The repo contains the code needed to create images to build and crossbuild Qt 5 and 6 for x64 and arm64 and to create images to build Qt applications with every Qt version. This is useful, for instance, for continuous integration:

![gitlab CI](shot.png)

# Images

Images for some Qt versions are already available here:

* https://hub.docker.com/repository/docker/carlonluca/qt-builder
* https://hub.docker.com/repository/docker/carlonluca/qt-dev

The **qt-builder** is an image to be used to cross-build Qt itself for amd64 and arm64. It includes all the headers and the libraries needed to build Qt from its sources.

The **qt-dev** images are images that include a prebuilt Qt directory with its runtime dependencies for the specific architecture. This image can be used to build an application and to run it in the container.

# Qt Builder

Building the Qt builder is straightforward. This is a small changelog of the versions (referring to the tags):

* 1: first version that builds Qt < 6.2.0;
* 2: includes an updated cmake that builds Qt >= 6.2.0.

## Qt 5

To build Qt 5.x for x64:

```
docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_amd64.sh:/build_amd64.sh carlonluca/qt-builder:focal \
    /build_amd64.sh 5.12.11 https://download.qt.io/official_releases/qt/5.12/5.12.11/single/
```

to build Qt 5.x for arm64:

```
docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_aarch64.sh:/build_aarch64.sh carlonluca/qt-builder:focal \
    /build_aarch64.sh 5.12.11 https://download.qt.io/official_releases/qt/5.12/5.12.11/single/
```

## Qt 6

Qt 6 requires a different crossbuild procedure, so build both archs at the same time:

```
docker run --rm -it --name qt-builder -v $PWD/qt_export:/root/export \
    -v $(pwd)/builder/build_qt6.sh:/build_qt6.sh carlonluca/qt-builder:focal \
    /build_qt6.sh 6.1.2 https://download.qt.io/official_releases/qt/6.1/6.1.2/single/
```

# Qt Dev Image

Once packages are ready in the qt_export directory you can build the dev image.

## Qt 5

```
docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t ... . -f Dockerfile_5.15.2
```

## Qt 6

```
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --build-arg QTVER=6.1.2 -t ... -f Dockerfile_6.x .
```