FROM bitriseio/android-ndk:latest

RUN yes |  sdkmanager "cmake;3.10.2.4988404"
ENV PATH ${PATH}:${ANDROID_HOME}/cmake