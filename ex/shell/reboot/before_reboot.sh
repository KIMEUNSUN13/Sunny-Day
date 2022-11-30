#!/bin/bash

# Reboot 절차
# 1. 프로세스 백업 필요 -> 리부트 후 올라오지 않는 프로세스 존재
# 2. 라우트 테이블 백업 필요 -> 단순 명령어로 추가해둔 정책은 리부트 후에 사라짐
# 3. 파일시스템 마운트 확인 필요 -> blkid가 /etc/fstab과 다른 경우 리부팅 시 오류

####
# 4. 사용자별 환경변수, 사용자별 프로세스
# cut -f1,6 -d: /etc/passwd
# .bashrc, .bash_profile
  # alias
# 루트
# /etc/profile

# find rm
# find ./ -mtime -10 (현재 시간으로부터 10일전에 수정된 파일)
# 지우는거
###

# 개선점이 많은 Reboot Script!
# 1. before, after 스크립트에 중복 코드 존재
# 2. 실행 시키기 위해 chmod u+x 필요
# 3. 여러대의 서버의 경우 스크립트를 전달(scp) 후 실행(ssh user@ip 'command')
#      3-1. 만약 스트립트에 변경사항이 있다면?

## (before) VM Reboot Process  ##

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "You are not running as the root user"
        exit 1;
fi

DATE="$(/usr/bin/date +%Y-%m-%d)"
WORK_DIR=/root/reboot/${DATE}

/usr/bin/mkdir -p ${WORK_DIR}

#================#
#     Procces    #
#================#
/usr/bin/systemctl list-units >> ${WORK_DIR}/systemctl-before.log
/usr/bin/ps aux >> ${WORK_DIR}/psaux-before.log
/usr/bin/netstat -anlp >> ${WORK_DIR}/netstat-before.log

#================#
#  Route Table   #
#================#
/usr/sbin/ip route |column -t >> ${WORK_DIR}/route-before.log

#================#
#   Filesystem   #
#================#
block_storage=(app data); 
for i in ${!block_storage[@]}; do
	FSTAB="$(/usr/bin/awk '{
					UUID=$1; 
					MNT=$2; 
					if(MNT=="/'${block_storge[$i]}'") 
						print UUID 
				}' /etc/fstab)";

	BLKID="$(/usr/sbin/blkid |/usr/bin/grep ${block_storge[$i]}vg |/usr/bin/awk '{ print $2 }')";

	if [ "${FSTAB}"="${BLKID}" ]; then
		/usr/bin/echo "/${block_storage[$i]}  No Problem!"
	fi
done

