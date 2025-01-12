#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8
# $FreeBSD: head/tools/regression/pjdfstest/tests/unlink/10.t 211352 2010-08-15 21:24:17Z pjd $

desc="unlink returns EPERM if the parent directory of the named file has its immutable or append-only flag set"

dir=`dirname $0`
. ${dir}/../misc.sh

require chflags

echo "1..30"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755

expect 0 create ${n0}/${n1} 0644
expect 0 chflags ${n0} SF_IMMUTABLE
expect EPERM unlink ${n0}/${n1}
expect 0 chflags ${n0} none
expect 0 unlink ${n0}/${n1}

expect 0 create ${n0}/${n1} 0644
expect 0 chflags ${n0} SF_NOUNLINK
expect 0 unlink ${n0}/${n1}
expect 0 chflags ${n0} none

expect 0 create ${n0}/${n1} 0644
expect 0 chflags ${n0} SF_APPEND
todo FreeBSD:ZFS "Removing a file from a directory protected by SF_APPEND should return EPERM."
expect EPERM unlink ${n0}/${n1}
expect 0 chflags ${n0} none
todo FreeBSD:ZFS "Removing a file from a directory protected by SF_APPEND should return EPERM."
expect 0 unlink ${n0}/${n1}

push_requirement chflags_UF_IMMUTABLE
	expect 0 create ${n0}/${n1} 0644
	expect 0 chflags ${n0} UF_IMMUTABLE
	expect EPERM unlink ${n0}/${n1}
	expect 0 chflags ${n0} none
	expect 0 unlink ${n0}/${n1}
pop_requirement

push_requirement chflags_UF_NOUNLINK
	expect 0 create ${n0}/${n1} 0644
	expect 0 chflags ${n0} UF_NOUNLINK
	expect 0 unlink ${n0}/${n1}
	expect 0 chflags ${n0} none
pop_requirement

push_requirement chflags_UF_APPEND
	expect 0 create ${n0}/${n1} 0644
	expect 0 chflags ${n0} UF_APPEND
	expect EPERM unlink ${n0}/${n1}
	expect 0 chflags ${n0} none
	expect 0 unlink ${n0}/${n1}
pop_requirement

expect 0 rmdir ${n0}
