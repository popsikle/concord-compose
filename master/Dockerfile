FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION 0.23.0
ENV PKG_RELEASE 1.0

WORKDIR /tmp
RUN \
  apt-get update && \
  apt-get install -y curl openjdk-6-jre-headless docker.io unzip python2.7-minimal && \
  curl -s -O https://downloads.mesosphere.io/master/ubuntu/14.04/mesos_${VERSION}-${PKG_RELEASE}.ubuntu1404_amd64.deb && \
  dpkg --unpack mesos_${VERSION}-${PKG_RELEASE}.ubuntu1404_amd64.deb && \
  apt-get install -f -y && \
  rm mesos_${VERSION}-${PKG_RELEASE}.ubuntu1404_amd64.deb && \
  apt-get clean

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
RUN ln -sf /usr/lib/libmesos.so /usr/lib/libmesos-0.23.1.so

EXPOSE 5050
CMD ["mesos-master"]
