FROM ubuntu:16.04

MAINTAINER Thomas Schmidt

ENV ANDROID_HOME /opt/android-sdk

ENV ANDROID_SDK_VERSION="25.2.5"

# ------------------------------------------------------
# --- Environments and base directories

# Environments
# - Language
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"
    
# ------------------------------------------------------
# --- Base pre-installed tools
RUN apt-get update -qq
    
# Generate proper EN US UTF-8 locale
# Install the "locales" package - required for locale-gen
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales && \ 
    locale-gen en_US.UTF-8

COPY README.md /README.md

WORKDIR /tmp

# Installing packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        git \
        file \
        curl \
        wget \
        lib32stdc++6 \
        lib32z1 \
        lib32z1-dev \
        lib32ncurses5 \
        libc6-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        m4 \
        ncurses-dev \
        ocaml \
        openssh-client \
        pkg-config \
        python-software-properties \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get clean

# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME
RUN wget -q -O tools.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip && \
    unzip -q tools.zip && \
    rm -fr $ANDROID_HOME tools.zip && \
    mkdir -p $ANDROID_HOME && \
    mv tools $ANDROID_HOME/tools
    
# Add android commands to PATH
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
# RUN sdkmanager --list


# Accept "android-sdk-license" before installing components, no need to echo y for each component
# License is valid for all the standard components in versions installed from this file
# Non-standard components: MIPS system images, preview versions, GDK (Google Glass) and Android Google TV require separate licenses, not accepted there
RUN mkdir -p ${ANDROID_HOME}/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > ${ANDROID_HOME}/licenses/android-sdk-license



# ------------------------------------------------------
# --- Install Gradle from PPA

# Gradle PPA
RUN apt-get update
RUN apt-get -y install gradle
RUN gradle -v

# ------------------------------------------------------
# --- Install Maven 3 from PPA

RUN apt-get purge maven maven2
RUN apt-get update
RUN apt-get -y install maven
RUN mvn --version

# ------------------------------------------------------
# --- Install additional packages

# Required for Android ARM Emulator
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libqt5widgets5
ENV QT_QPA_PLATFORM offscreen
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ANDROID_HOME}/tools/lib64

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"
