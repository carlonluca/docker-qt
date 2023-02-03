# Intro

The repo contains the code needed to create images to build and crossbuild Qt 5 and 6 for x64/arm64 Linux and armv7a/armv8a Android. This is useful, for instance, for continuous integration:

Articles with more info: https://bugfreeblog.duckdns.org/tag/docker-qt.

Summary of all available images with the included features: https://bugfreeblog.duckdns.org/docker-qt-tags.

![docker Qt](logo.svg)

![gitlab CI](shot.png)

# Images

Images for some Qt versions are already available here:

* https://hub.docker.com/r/carlonluca/qt-builder
* https://hub.docker.com/r/carlonluca/qt-dev

The **qt-builder** is an image to be used to cross-build Qt itself for the available platforms. It includes all the headers and the libraries needed to build and crossbuild Qt from its sources. By using the build_* scripts, Qt tarballs are exported. The builder in docker hub is only built for the x64 architecture.

The **qt-dev** images are images that include prebuilt Qt installations. It includes all the deps needed to build and run Qt apps. This image is available for two archs in docker hub: the arm64 version only includes the arm64 build of Qt, the x64 version includes the x64 build and the Android builds.

# Qt Builder

Before trying to build a Qt version, you'll need a proper builder image. The builder image includes all the deps needed to complete the build process. At the moment, I created two builders: one based on focal and one based on jammy. The one based on focal must be used to build Qt 5, the one based on jammy is used to build Qt 6.

Once the builder is available, you can use the builder to run the build of Qt itself. Refer to the build scripts at this point. Once the build script is done, you should find Qt packages available in the export directory. Those packages are used to create the dev images.

# Qt Dev Image

Once packages are ready in the qt_export directory you can build the dev image. Use the dockerfiles in the root directory to build this image, according to the examples below.

## Qt 5

```
docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t ... . -f Dockerfile_5.15.2
```

## Qt 6

```
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --build-arg QTVER=6.1.2 -t ... -f Dockerfile_6.x .
```