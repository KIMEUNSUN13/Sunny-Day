#!/bin/bash

echo 'iteyes7979!@' | passwd --stdin ncloud

useradd iteyes
echo 'iteyes7979!@' | passwd --stdin iteyes

cp -a /etc/sudoers /etc/sudoers.bak
echo "iteyes  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

mkdir -p /root/script_bak
cp -a /etc/yum.conf /root/script_bak/yum.conf.bak

sed -i "s/exclude=xe-guest-utilities*/exclude=xe-guest-utilities*,kernel*,centos-release*/g" /etc/yum.conf

cp -a /etc/sysconfig/kernel /root/script_bak/kernel.bak
sed -i "s/UPDATEDEFAULT=yes/UPDATEDEFAULT=no/g" /etc/sysconfig/kernel

cp -a /etc/profile /root/script_bak/profile.bak
echo "export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '" >> /etc/profile


sed -i "s/HISTSIZE=500/HISTSIZE=100000/g"  /etc/profile
sed -i "s/HISTFILESIZE=0//g" /etc/profile

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

systemctl disable firewalld
systemctl stop firewalld

ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtim