FROM 42nerds/gitlab-cordova

ENV PATH ${PATH}:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS}
ENV GRADLE_VERSION gradle-2.2.1
ENV GRADLE_USER_HOME /root/.gradle

ADD google.list /etc/apt/sources.list.d/google.list
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install unzip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN wget https://services.gradle.org/distributions/${GRADLE_VERSION}-all.zip && \
    mkdir -p ${GRADLE_USER_HOME}/wrapper/dists && \
    mv ${GRADLE_VERSION}-all.zip ${GRADLE_USER_HOME}/wrapper/dists/

RUN echo y | android update sdk -u -a --filter extra-android-m2repository,extra-android-support,extra-google-m2repository
RUN npm install -g ionic