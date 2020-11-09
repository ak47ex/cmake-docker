FROM bitriseio/android-ndk:latest

RUN yes |  sdkmanager "cmake;3.10.2.4988404"
RUN yes |  sdkmanager --licenses
RUN yes |  sdkmanager --install "ndk;21.3.6528147"

ENV PATH ${PATH}:${ANDROID_HOME}/cmake
