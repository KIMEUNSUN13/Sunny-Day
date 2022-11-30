#!/bin/bash
#set -x

HOST=$(hostname)
MSG="$(df -h |\
	awk '{ 
		gsub("%", "");
		USE=$5;
		PATH=$6;
		if( USE > 10 ) 
			print PATH, " 파티션이 ", USE, "% 사용중 입니다." 
	     }' |\
	grep -v "^[A-Z]"
)"
MNT="$(echo ${MSG} |awk '{print $1}')"

if [ ${#MSG} -gt 1 ]
then
	echo "==========================="
	echo "${HOST}"
	echo "${MSG}"
	echo "==========================="
fi

