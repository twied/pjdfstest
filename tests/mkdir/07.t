#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8
# $FreeBSD: head/tools/regression/pjdfstest/tests/mkdir/07.t 211352 2010-08-15 21:24:17Z pjd $

desc="mkdir returns ELOOP if too many symbolic links were encountered in translating the pathname"

dir=`dirname $0`
. ${dir}/../misc.sh

require ftype_symlink

echo "1..6"

n0=`namegen`
n1=`namegen`

expect 0 symlink ${n0} ${n1}
expect 0 symlink ${n1} ${n0}
expect ELOOP mkdir ${n0}/test 0755
expect ELOOP mkdir ${n1}/test 0755
expect 0 unlink ${n0}
expect 0 unlink ${n1}
