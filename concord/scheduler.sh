#!/bin/bash
# requires java8
set -ex

CURRENT_IP=$(ifconfig eth0 | awk '/inet addr/{print substr($2,6)}')
PUBLIC_IP=$(env | grep ADVERTISED_HOST | grep KAFKA | head -n 1 | cut -f2 -d'=')

/usr/bin/concord_fetch || exit $?

concord_scheduler_version=${CONCORD_VERSION}
source_jar="/usr/local/share/concord-scheduler-${concord_scheduler_version}.jar"

declare -a java_args
addJava() { java_args=( "${java_args[@]}" "$1" ); }

addJava "-Djava.library.path=/usr/local/lib"
addJava "-DMESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so"
addJava "-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=${CURRENT_IP}:8976"
addJava "-server"
addJava "-Xms2g -Xmx2g"
addJava "-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled"
addJava "-XX:+PrintGCDateStamps -verbose:gc -XX:+PrintGCDetails -Xloggc:/var/log/concord_gc.log"
addJava "-XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M"
addJava "-Dsun.net.inetaddr.ttl=60"
addJava "-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/concord_heap_dump_$(date +%s.%N).hprof"
addJava "-Dcom.sun.management.jmxremote.port=8999"
addJava "-Dcom.sun.management.jmxremote.authenticate=false"
addJava "-Dcom.sun.management.jmxremote.ssl=false"

if [[ -n ${JVM_OPTS+x} ]]; then
  for arg in ${JVM_OPTS[@]}; do addJava "$arg"; done
fi

exec java ${java_args[@]} -cp $source_jar \
     com.concord.scheduler.Scheduler --listen 0.0.0.0:11211 \
     --advertise-external ${PUBLIC_IP} \
     --advertise-internal ${CURRENT_IP} \
     --concord-master zk://zookeeper:2181/concord \
     --mesos-master zk://zookeeper:2181/mesos \
     --kafka-path zk://zookeeper:2181/kafka \
     --framework-name concord
