FROM jenkins/jenkins 2.164.1

USER root

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends openjdk-8-jdk unzip curl  python-pip  python2.7&& \
    apt-get clean

RUN pip install requests

ENV USR_LOCAL /usr/local
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C ${USR_LOCAL}
ENV ANDROID_HOME ${USR_LOCAL}/android-sdk-linux
ENV ANDROID_SDK ${USR_LOCAL}/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN echo "export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools" >> /etc/profile

ENV ANDROID_SDK_COMPONENTS tools,platform-tools,build-tools-26.0.2,build-tools-27.0.3,build-tools-28.0.3,android-26,android-27,android-28,extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"

ENV TERM dumb


# GRADLE


# Gradle props
ENV JAVA_OPTS "-Xms1g -Xmx4g"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"
WORKDIR /usr/local
ENV GRADLE_URL http://services.gradle.org/distributions/gradle-4.10.1-all.zip
ADD ${GRADLE_URL} gradle-4.10.1-bin.zip
RUN unzip gradle-4.10.1-bin.zip && ln -s gradle-4.10.1 gradle
ENV GRADLE_HOME /usr/local/gradle
RUN echo "export PATH=${PATH}:${GRADLE_HOME}/bin" >> /etc/profile
ENV PATH ${PATH}:${GRADLE_HOME}/bin