#!/bin/bash

## (after) VM Reboot Process ##

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "You are not running as the root user"
        exit 1;
fi

DATE="$(/usr/bin/date +%Y-%m-%d)"
WORK_DIR=/root/reboot/${DATE}

#================#
#    Procces     #
#================#
/usr/bin/systemctl list-units >> ${WORK_DIR}/systemctl-after.log
/usr/bin/ps aux >> ${WORK_DIR}/psaux-after.log
/usr/bin/netstat -anlp >> ${WORK_DIR}/netstat-after.log

#================#
#  Route Table   #
#================#
/usr/sbin/ip route |column -t >> ${WORK_DIR}/route-after.log

#================#
#  After Reboot  #
#================#
/usr/bin/diff ${WORK_DIR}/systemctl-before.log ${WORK_DIR}/systemctl-after.log >> ${WORK_DIR}/diff-systemctl.log
/usr/bin/diff ${WORK_DIR}/psaux-before.log ${WORK_DIR}/psaux-after.log >> ${WORK_DIR}/diff-psaux.log
/usr/bin/diff ${WORK_DIR}/netstat-before.log ${WORK_DIR}/netstat-after.log >> ${WORK_DIR}/diff-netstat.log

#================#
#   Add Route    #
#================#
# 라우트 테이블에 변동사항이 생겼다면,
# /etc/sysconfig/network-scripts/route-ethX에 추가
# /etc/sysconfig/network-scripts/ifup-routes ethX 실행