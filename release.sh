#!/bin/bash
# Qing.

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
echo "WORKDIR: $WORKDIR "
cur_time=`date +%y%m%d`
APP_DIR=${WORKDIR}/srs/trunk
INSTALL_DIR=${WORKDIR}/install

platform="centos"
dst_platform=""
dst_release="debug"
TOOLCHAIN=0
DEBUG_MODE=1


if [ $# -gt 0 ]; then
    platform=$(echo $1 | tr '[A-Z]' '[a-z]')
    echo "platform: $1"
    if [ "nt966x" == $platform ]; then
        TOOLCHAIN=1
    elif [ "nt966x_d048" == $platform ]; then
        TOOLCHAIN=2
    else
        TOOLCHAIN=0
    fi

    if [ "release" == $(echo $2 | tr '[A-Z]' '[a-z]') ]; then
        DEBUG_MODE=0
    else
        DEBUG_MODE=1
    fi
else
    TOOLCHAIN=0
fi

if [ "$platform" == "ubuntu" ]; then
    dst_platform="ubuntu"
else
    dst_platform="centos"
fi

if [ "$DEBUG_MODE" == "1" ]; then
    dst_release="debug"
else
    dst_release="release"
fi

echo "dst_platform: ${dst_platform}"

echo "TOOLCHAIN:${TOOLCHAIN}, DEBUG_MODE:${DEBUG_MODE}, PLATFORMS:${platform}"

function compile()
{
    cd ${WORKDIR}/srs/trunk
    
    make clean
    ./configure --prefix=${INSTALL_DIR}
    if [ $? -ne 0  ]; then
        return 1
    fi
    make
    if [ $? -ne 0  ]; then
        return 1
    fi
    make install
    
    cd -
}

function distribution()
{
    cp -Rf ${INSTALL_DIR}/* $PKG_DIR

    if [ -f ${WORKDIR}/srs/trunk/startup.sh ]; then
        cp -f ${WORKDIR}/srs/trunk/startup.sh $PKG_DIR/
    fi

if false; then
    mkdir -p ${PKG_DIR}/bin
    mkdir -p ${PKG_DIR}/conf

    if [ -f ${WORKDIR}/srs/trunk/objs/srs ]; then
        cp -f ${WORKDIR}/srs/trunk/objs/srs $PKG_DIR/bin
    fi
    
    if [ -f ${WORKDIR}/srs/trunk/conf/srs.conf ]; then
        cp -f ${WORKDIR}/srs/trunk/conf/srs.conf $PKG_DIR/conf
    fi


    if [ -f ${WORKDIR}/bin/README.md ]; then
        cp -f ${WORKDIR}/bin/README.md $PKG_DIR
    fi
    
    if [ -f ${WORKDIR}/start.sh ]; then
        cp -f ${WORKDIR}/start.sh $PKG_DIR
    fi
fi

}

function release()
{
    compile
    if [ $? -ne 0  ]; then
        return 1
    fi
 
    cd ${WORKDIR}
     
    #PKG_DIR=vmp-srs-${dst_platform}.${cur_time}.${CODE_VERSION}
    PKG_DIR=vmp-srs-${dst_platform}.${cur_time}
    if [ -d $PKG_DIR ]; then
        rm -rf ${PKG_DIR}/*
    else
        mkdir ${PKG_DIR}
    fi

    distribution 
    if [ $? -ne 0  ]; then
        return 1
    fi
   
    #if [ -f ${PKG_DIR}.tgz ]; then
    #    rm ${PKG_DIR}.tgz
    #fi
    if ls vmp-srs-*.tgz >/dev/null 2>&1; then
        rm vmp-srs-*.tgz
    fi
    echo "tar -zcvf ${PKG_DIR}.tgz ${PKG_DIR}"
    tar -zcvf ${PKG_DIR}.tgz ${PKG_DIR} 
    if [ $? -ne 0  ]; then
        return 1
    fi

    if [ -d $PKG_DIR ]; then
        rm -rf ${PKG_DIR}
    fi
    
    cd -
}

release

