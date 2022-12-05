#!/bin/bash 

echo 'root' | passwd --stdin root
echo 'centos' | passwd --stdin centos

useradd infadm
echo 'infadm' | passwd --stdin infadm
usermod -a -G wheel infadm

useradd wasadm
echo 'wasadm' | passwd --stdin wasadm

cp -a /etc/sudoers /etc/sudoers.bak 
{
    # echo "%wheel  ALL=(ALL)       ALL" 
    # echo "#%wheel  ALL=(ALL)       NOPASSWD: ALL"
    echo "wasadm  ALL=(ALL)       ALL"
}| tee -a /etc/sudoers 

cp -a /etc/pam.d/su /etc/pam.d/su.bak 
sed -i "s/#auth required pam_wheel.so use_uid/auth required	pam_wheel.so use_uid/g" /etc/pam.d/su

# PermitRootLogin no
cp -a /etc/securetty /etc/securetty.bak 
sed -ri "s/pts\/[0-9]//g" /etc/securetty

# authconfig 사용??
cp -a /etc/security/pwquality.conf /etc/security/pwquality.conf.bak
{
    echo "lcredit=-1" # 영문 소문자
    echo "ucredit=-1" # 영문 대문자
    echo "dcredit=-1" # 숫자
    echo "ocredit=-1" # 특수문자
    echo "minlen=8"   # 최소 패스워드 길이 설정
}| tee -a /etc/security/pwquality.conf

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd

for NUM in $(seq 2 7); do mv /etc/sysconfig/network-scripts/ifcfg-eth${NUM} /etc/sysconfig/network-scripts/ifcfg-eth${NUM}.bak; done >/dev/null 2>&1
systemctl restart network

systemctl disable firewalld 
systemctl stop firewalld

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
