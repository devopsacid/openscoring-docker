### Container OPENSCORING-1.3-SNAPSHOT
### Dockerfile to create OpenScoring.io PMML modeling container with exposed port 8080
### Michal Maxian, michal@maxian.sk 

FROM buildpack-deps:jessie-scm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    maven\
    openjdk-7-jdk \
    unzip \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN cd /opt && git clone https://github.com/openscoring/openscoring.git && \
    mkdir -p /opt/openscoring/model-dir && cd /opt/openscoring && \
    mvn clean install

ADD application.conf /opt/openscoring/application.conf

EXPOSE 8080

ENTRYPOINT java -Dconfig.file=/opt/openscoring/application.conf -jar /opt/openscoring/openscoring-server/target/server-executable-1.3-SNAPSHOT.jar --model-dir /opt/openscoring/model-dir
