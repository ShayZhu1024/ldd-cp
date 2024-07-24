#!/bin/bash
################################
# Author: ShayZhu
# Contact: shayzhu@hotmail.com
# Version: 1.0.0
# Date: 2024-07-24
# Description:
################################



EXE=$1
mkdir ./rootfs/
cd ./rootfs/

ln -s usr/lib/     lib
ln -s usr/libx32/  libx32
ln -s usr/lib64    lib64 
ln -s usr/lib32    lib32
ln -s usr/bin      bin
ln -s usr/sbin     sbin

mkdir -p usr/lib
mkdir -p usr/lib64
mkdir -p usr/lib32
mkdir -p usr/libx32

mkdir -p usr/bin
mkdir -p usr/sbin
mkdir -p usr/local/bin
mkdir -p usr/local/sbin


lddDir=`ldd $EXE | awk '{print $3}' | egrep -v ${EXE%/*}` 
lddDir="$lddDir `ldd $EXE | egrep -v "=>" | egrep / | awk '{print $1}'`"
for line in $lddDir ; do
    dir=${line%/*}     #remove filename
    destDir=${dir#/*}  #remove /
    if [ -L $line ]; then #sovle linked file
        sourceFile=`readlink -f $line`
        sourceFileDir=`dirname $sourceFile`
        destSourceFileDir=${sourceFileDir#/*}
        if [ !  -e $destSourceFileDir ]; then 
            mkdir -p $destSourceFileDir
        fi
        cp -a  `readlink -f $line`  $destSourceFileDir
    fi
    if [ ! -e $destDir ]; then 
        mkdir -p $destDir
    fi
    cp -a $line $destDir
done
