#!/bin/sh
# vim: filetype=sh noexpandtab ts=8 sw=8
# $FreeBSD: head/tools/regression/pjdfstest/tests/mkfifo/11.t 211352 2010-08-15 21:24:17Z pjd $

desc="mkfifo returns ENOSPC if there are no free inodes on the file system on which the file is being created"

dir=`dirname $0`
. ${dir}/../misc.sh

require ftype_fifo

[ "${os}:${fs}" = "FreeBSD:UFS" ] || quick_exit

echo "1..3"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755
n=`mdconfig -a -n -t malloc -s 512k` || exit
newfs /dev/md${n} >/dev/null || exit
mount /dev/md${n} ${n0} || exit
i=0
while :; do
	mkfifo ${n0}/${i} >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		break
	fi
	i=`expr $i + 1`
done
expect ENOSPC mkfifo ${n0}/${n1} 0644
umount /dev/md${n}
mdconfig -d -u ${n} || exit
expect 0 rmdir ${n0}
