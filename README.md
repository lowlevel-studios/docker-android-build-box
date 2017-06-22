# Docker Android Build Box


[![Build Status](https://travis-ci.org/bohsen/docker-android-build-box.svg?branch=master)](https://travis-ci.org/bohsen/docker-android-build-box)

[![docker icon](http://dockeri.co/image/mingc/android-build-box)](https://hub.docker.com/r/mingc/android-build-box/)


## Introduction

A **docker** image build with **Android** build environment. This is based on the fabulous work by [Ming Chen](https://github.com/mingchen/docker-android-build-box). So thanks goes to him for providing this.


## What's Inside

It include following components:

* Ubuntu 16.04
* Android SDK 21 22 23 24 25
* Android build tools 25 25.0.1 25.0.2 25.0.3 26.0.0
* extra-android-m2repository
* extra-google-google\_play\_services
* extra-google-m2repository


## Docker Pull Command

The docker image is publicly automated build on [Docker Hub](https://hub.docker.com/r/bohsen/android-build-box/) based on Dockerfile in this repo, so there is no hidden staff in image. To pull the latest docker image:

    docker pull bohsen/android-build-box:latest


## Usage

### Use image to build Android project

You can use this docker image to build your Android project with a single docker command:

    cd <android project directory>  # change working directory to your project root directory.
    docker run --rm -v `pwd`:/project bohsen/android-build-box bash -c 'cd /project; ./gradlew build'



### Use image for Bitbucket pipeline

If you have Android code in Bitbucket and want to use it pipeline to build your Android code, you can simply specific this docker image.
Here is an example of `bitbucket-pipelines.yml`

    image: bohsen/android-build-box:latest

    pipelines:
      default:
        - step:
            script:
              - chmod +x gradlew
              - ./gradlew assemble


## Docker Build Image

If you want to build docker image by yourself, you can use following `docker build` command to build your image.
The image itself up to 5.5 GB, check your free disk space before build it.

    docker build -t android-build-box .


## Contribution

If you want to enhance this docker image for fix something, feel free to send [pull request](https://github.com/bohsen/docker-android-build-box/pull/new/master).


## References

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* [Build your own image](https://docs.docker.com/engine/getstarted/step_four/)
* [uber android build environment](https://hub.docker.com/r/uber/android-build-environment/)
* [Refactoring a Dockerfile for image size](https://blog.replicated.com/2016/02/05/refactoring-a-dockerfile-for-image-size/)
