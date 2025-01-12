#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8
# $FreeBSD: head/tools/regression/pjdfstest/tests/mknod/09.t 211352 2010-08-15 21:24:17Z pjd $

desc="mknod returns EPERM if the parent directory of the file to be created has its immutable flag set"

dir=`dirname $0`
. ${dir}/../misc.sh

require chflags
require ftype_fifo

echo "1..30"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755

expect 0 mknod ${n0}/${n1} f 0644 0 0
expect 0 unlink ${n0}/${n1}

expect 0 chflags ${n0} SF_IMMUTABLE
expect EPERM mknod ${n0}/${n1} f 0644 0 0
expect 0 chflags ${n0} none
expect 0 mknod ${n0}/${n1} f 0644 0 0
expect 0 unlink ${n0}/${n1}

expect 0 chflags ${n0} SF_APPEND
expect 0 mknod ${n0}/${n1} f 0644 0 0
expect 0 chflags ${n0} none
expect 0 unlink ${n0}/${n1}

expect 0 chflags ${n0} SF_NOUNLINK
expect 0 mknod ${n0}/${n1} f 0644 0 0
expect 0 unlink ${n0}/${n1}
expect 0 chflags ${n0} none

push_requirement chflags_UF_IMMUTABLE
	expect 0 chflags ${n0} UF_IMMUTABLE
	expect EPERM mknod ${n0}/${n1} f 0644 0 0
	expect 0 chflags ${n0} none
	expect 0 mknod ${n0}/${n1} f 0644 0 0
	expect 0 unlink ${n0}/${n1}
pop_requirement

push_requirement chflags_UF_APPEND
	expect 0 chflags ${n0} UF_APPEND
	expect 0 mknod ${n0}/${n1} f 0644 0 0
	expect 0 chflags ${n0} none
	expect 0 unlink ${n0}/${n1}
pop_requirement

push_requirement chflags_UF_NOUNLINK
	expect 0 chflags ${n0} UF_NOUNLINK
	expect 0 mknod ${n0}/${n1} f 0644 0 0
	expect 0 unlink ${n0}/${n1}
	expect 0 chflags ${n0} none
pop_requirement

expect 0 rmdir ${n0}
