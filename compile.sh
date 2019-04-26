#!/bin/bash

#安装依赖包
yum -y install gcc glibc glibc-devel make nasm pkgconfig lib-devel openssl-devel expat-devel gettext-devel libtool mhash.x86_64 perl-Digest-SHA1.x86_64


cd ./srs/trunk

#debug
#./configure --prefix=/usr/local/srs --with-ssl --with-hls --with-hds --with-dvr --with-nginx --with-http-callback --with-http-server --with-stream-caster --with-http-api --with-transcode --with-ingest --with-stat --with-librtmp --with-research --with-utest --with-gperf --with-gprof

#release
./configure --prefix=/usr/local/srs  --with-ssl --with-hls --with-hds --with-dvr --with-nginx --without-ffmpeg --with-transcode --with-ingest --with-stat --with-http-callback --with-http-server --with-stream-caster --with-http-api --with-librtmp --with-research --without-utest --without-gperf --without-gmc --without-gmp --without-gcp --without-gprof --without-arm-ubuntu12 --without-mips-ubuntu12 --log-trace

make
make install
