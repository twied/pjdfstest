#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8
# $FreeBSD: head/tools/regression/pjdfstest/tests/mknod/04.t 211352 2010-08-15 21:24:17Z pjd $

desc="mknod returns ENOENT if a component of the path prefix does not exist"

dir=`dirname $0`
. ${dir}/../misc.sh

require ftype_fifo

echo "1..3"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755
expect ENOENT mknod ${n0}/${n1}/test f 0644 0 0
expect 0 rmdir ${n0}
