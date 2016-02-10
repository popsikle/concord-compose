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

# Concord Stuff
ENV CONCORD_VERSION 0.3.10

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    software-properties-common apt-transport-https curl && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    bzip2 libntl0 libmpfr4 libssl1.0.0 libgflags2 libboost-thread1.55.0 \
    libboost-regex1.55.0 libboost-program-options1.55.0 libboost-system1.55.0 \
    libboost-filesystem1.55.0 libboost-date-time1.55.0 libboost-iostreams1.55.0 \
    libevent-dev libunwind8 libdouble-conversion1 \
    liblz4-1 liblzma5 libsnappy1 libjemalloc1 libgoogle-glog-dev zlib1g \
    libbz2-1.0 libarchive13 libcurl3-nss libsvn1 libsasl2-2 libapr1 \
    lttng-tools liblttng-ust0 ruby2.0 ruby2.0-dev scons build-essential \
    cmake libjemalloc1 git && \
  add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get -y upgrade \
    cpp-4.8 g++-4.8 gcc-4.8 gcc-4.8-base gcc-4.9-base libasan0 libatomic1 \
    libcloog-isl4 libgcc-4.8-dev libgcc1 libgomp1 libitm1 libquadmath0 \
    libstdc++-4.8-dev libstdc++6 libtsan0 && \
  rm -rf /var/lib/apt/lists/*

RUN cd / && \
  curl -L https://storage.googleapis.com/concord-release/concord-${CONCORD_VERSION}-bin.tar.gz | tar zvxf -

EXPOSE 5051
CMD ["mesos-slave"]