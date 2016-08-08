FROM java:openjdk-8-jdk-alpine

RUN apk add --no-cache git curl zip unzip bash ttf-dejavu

RUN mkdir -p /var/run/sshd

ADD start /var/lib/jenkins/start
ADD config_slave.xml /var/lib/jenkins/config_slave.xml
RUN mkdir /var/lib/jenkins/workspace

WORKDIR /var/lib/jenkins
CMD ./start