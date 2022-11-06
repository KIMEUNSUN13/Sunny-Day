#!/bin/bash 

echo 'centos' | passwd --stdin centos

useradd eunsun 
echo 'eunsun' | passwd --stdin eunsun

cp -a /etc/sudoers /etc/sudoers.bak 
echo "eunsun  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers 

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

systemctl restart sshd

systemctl disable firewalld 
systemctl stop firewalld

ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtim