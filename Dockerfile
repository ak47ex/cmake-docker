FROM ubuntu

WORKDIR /

SHELL ["/bin/bash", "-c"]

# To avoid "tzdata" asking for geographic area
ARG DEBIAN_FRONTEND=noninteractive

# Dependencies and needed tools
RUN apt update -qq && apt install -qq -y openjdk-11-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6  libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget

# Version of tools:
# In Code
ARG ANDROID_CMD_LINE_TOOLS=linux-6858069_latest

# Download commandlinetools
RUN mkdir /opt/android \
&& mkdir /opt/android/cmdline-tools \
&& wget -q https://dl.google.com/android/repository/commandlinetools-${ANDROID_CMD_LINE_TOOLS}.zip -P /tmp \
&& unzip -q -d /opt/android/cmdline-tools /tmp/commandlinetools-${ANDROID_CMD_LINE_TOOLS}.zip \
&& mv /opt/android/cmdline-tools/cmdline-tools /opt/android/cmdline-tools/tools

ARG ANDROID_API_LEVEL=30
# https://developer.android.com/studio/releases/build-tools
ARG ANDROID_BUILD_TOOLS_LEVEL=30.0.2

ARG ANDROID_CMAKE_VERSION=3.18.1

# https://developer.android.com/studio/
# https://developer.android.com/ndk/downloads
ARG ANDROID_NDK_VERSION=22.0.7026061

# install packages and accept all licenses
RUN yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" "platforms;android-${ANDROID_API_LEVEL}" "platform-tools" "ndk;${ANDROID_NDK_VERSION}" "cmake;${ANDROID_CMAKE_VERSION}" --channel=3\
&& yes Y | /opt/android/cmdline-tools/tools/bin/sdkmanager --licenses

# Environment variables to be used for build
ENV ANDROID_HOME=/opt/android
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}
ENV PATH "$PATH:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:${ANDROID_NDK_HOME}"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

# Clean up
RUN rm /tmp/commandlinetools-${ANDROID_CMD_LINE_TOOLS}.zip
