#!/bin/bash


## (before) VM Reboot Process  ##

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "You are not running as the root user"
        exit 1;
fi

DATE="$(/usr/bin/date +%Y-%m-%d)"
WORK_DIR=/root/mgmt/${DATE}

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


