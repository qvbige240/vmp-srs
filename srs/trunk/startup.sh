#!/bin/bash

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
echo "WORKDIR: $WORKDIR "

cd $WORKDIR

function start_rtmp()
{
    ./objs/srs -c conf/srs.conf
}

start_rtmp

cd -
