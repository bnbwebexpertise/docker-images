FROM 42nerds/gitlab-cordova

ADD google.list /etc/apt/sources.list.d/google.list
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install unzip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

ENV GRADLE_VERSION gradle-2.2.1
ENV GRADLE_HOME /opt/${GRADLE_VERSION}
ENV PATH $PATH:$GRADLE_HOME/bin

RUN wget https://services.gradle.org/distributions/${GRADLE_VERSION}-all.zip && \
    unzip ${GRADLE_VERSION}-all.zip && \
    mv ${GRADLE_VERSION} /opt/ && \
    mkdir -p ${GRADLE_VERSION}/wrapper/dists
    mv ${GRADLE_VERSION}-all.zip ${GRADLE_VERSION}/wrapper/dists/

RUN echo y | android update sdk -u -a --filter extra-android-m2repository,extra-android-support,extra-google-m2repository
RUN npm install -g ionic

ENV GRADLE_USER_HOME ${GRADLE_HOME}
ENV PATH ${PATH}:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS}:${GRADLE_USER_HOME}/bin