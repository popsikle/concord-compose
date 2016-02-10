#!/bin/bash

set -ex
current=${PWD}
concord_scheduler_version=${CONCORD_VERSION}
source_jar="/usr/local/share/concord-scheduler-${concord_scheduler_version}.jar"
if [[ ! -f $source_jar ]]; then
    # -c continues partially downloaded files
    # -N if hash isn't the same as local file
    # Can't use -O or -N doesn't work
    cd /usr/local/share
    wget -c -N "https://storage.googleapis.com/concord-release/concord-scheduler-${concord_scheduler_version}.jar"
    if [[ $? != 0 ]]; then
        echo "Could not download ";
        exit $?
    fi
    cd $current
fi