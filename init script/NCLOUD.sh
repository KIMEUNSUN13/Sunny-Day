#!/bin/bash

# ncloud 패스워드 변경
echo 'iteyes7979!@' | passwd --stdin ncloud

# iteyes 계정 생성
useradd iteyes
# iteyes 패스워드 변경
echo 'iteyes7979!@' | passwd --stdin iteyes

# sudoers 파일 백업
cp -a /etc/sudoers /etc/sudoers.bak
# sudo 권한 명령 추가
echo "iteyes  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# 스크립트 백업 폴더 생성
mkdir -p /root/script_bak
# yum.conf 파일 백업
cp -a /etc/yum.conf /root/script_bak/yum.conf.bak

# yum  업데이트 예외처리
sed -i "s/exclude=xe-guest-utilities*/exclude=xe-guest-utilities*,kernel*,centos-release*/g" /etc/yum.conf

# kernel 파일 백업
cp -a /etc/sysconfig/kernel /root/script_bak/kernel.bak

# yum 업데이트시 kernel 업데이트 예외처리
sed -i "s/UPDATEDEFAULT=yes/UPDATEDEFAULT=no/g" /etc/sysconfig/kernel

# profile 파일 백업
cp -a /etc/profile /root/script_bak/profile.bak

# 시간을 설정할 수 있는 기능
echo "export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '" >> /etc/profile

# 메모리 영역에 기록되는 명령어 라인수
sed -i "s/HISTSIZE=500/HISTSIZE=100000/g"  /etc/profile

# 메모리 영역에 기록되는 명령어 사이즈 (사용한 명령어를 저장하고 싶지 않다면 아래처럼 HISTSIZE=0)
sed -i "s/HISTFILESIZE=0//g" /etc/profile

# limits 파일 백업
cp -a /etc/security/limits.conf /root/script_bak/limits.conf.bak
# 최대 열린 파일의 수
echo "*                soft    nofile          32768" >> /etc/security/limits.conf
echo "*                hard    nofile          65535"  >> /etc/security/limits.conf
# 최대 프로세스 수
echo "*                soft    nproc           32768" >> /etc/security/limits.conf
echo "*                hard    nproc           65535" >> /etc/security/limits.conf
# 최대 스택 크기
echo "*                soft    stack           65536" >> /etc/security/limits.conf
echo "*                hard    stack           65536" >> /etc/security/limits.conf
# 코아 파일 크기 제한
echo "*                soft    core            unlimited" >> /etc/security/limits.conf
echo "*                hard    core            unlimited" >> /etc/security/limits.conf
# 최대 잠금 메모리 주소 공간
echo "*                soft    memlock         unlimited" >> /etc/security/limits.conf
echo "*                hard    memlock         unlimited" >> /etc/security/limits.conf

# 백업 생성
cp -a /etc/sysctl.conf /root/script_bak/sysctl.conf.bak
# >> /etc/sysctl.conf 영구 적용 (재부팅시에 적용)
echo "net.ipv4.tcp_mem = 8192 87380 16777216" >> /etc/sysctl.conf
# Keepalive 소켓의 유지시간 https://devidea.tistory.com/60
echo "net.ipv4.tcp_keepalive_time = 180" >> /etc/sysctl.conf
# 네트워크 소켓 실행 시간 기록 기본값 1
echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
# 통신 종료 후 대기시간 설정 기본값 60(초)
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.config
# 재전송 패킷을 보내는 주기
echo "net.ipv4.tcp_keepalive_intvl = 30" >> /etc/sysctl.config
# 패킷을 보낼 최대 전송 횟수
echo "net.ipv4.tcp_keepalive_probes = 5" >> /etc/sysctl.conf
# SYN_RECEIVED 상태의 소켓(즉, connection incompleted)을 위한 queue 1024이상을 설정
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
# TCP 헤더의 특정한 부분을 뽑아내어 암호화 알고리즘을 이용하는 방식으로 Three-way Handshake가 성공적으로 이루어지지 않으면 더 이상 소스 경로를 거슬러 올라가지 않게 설정
# 0비활성화 1 활성화 https://blog.pages.kr/4
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
# 프록시 서버를 사용하는 경우에는 SYN의 retry 횟수 기본 값 : 5
echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.conf
# TCP 연결을 끊기 전에 재시도하는 횟수  https://waspro.tistory.com/406
echo "net.ipv4.tcp_retries2 = 2" >> /etc/sysctl.conf
# TCP 수신 버퍼크기 기본값 설정
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
# TCP 전송 버퍼크기 최대값 설정
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
# TCP 수신 버퍼크기 기본값 설정
echo "net.core.rmem_default = 16777216" >> /etc/sysctl.conf
#TCP 전송 버퍼크기 기본값 설정
echo "net.core.wmem_default = 16777216" >> /etc/sysctl.conf
# 옵션 메모리 버퍼의 최대 크기 증가 https://koromoon.blogspot.com/2019/06/sysctlconf.html
echo "net.core.optmem_max = 16777216" >> /etc/sysctl.conf
# 연결되지 않은 요청을 큐에 넣을 수 있는 최대 큐의 길이 https://techpad.tistory.com/62
echo "net.core.somaxconn = 8192" >> /etc/sysctl.conf
# 백로그에 들어오는 소켓 개수를 설정
echo "net.core.netdev_max_backlog = 32768" >> /etc/sysctl.conf
# 65kb 이상의 큰 TCP 윈도우 스케일링 사용
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
# SYNC 패킷을 전송한 후 일부 ACK를 받지 못했을 경우 선택적으로 받지 못한 ACK 패킷을 받도록 설정
echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
# kernel의 정보를 나타나게 하는 콤보 키 비활성 : 0 활성 : 1 https://rhlinux.tistory.com/17
echo "kernel.sysrq = 1" >> /etc/sysctl.conf
# 하나의 메시지 큐에서의 최대 바이트 수를 지정 기본설정 16348
# 바이트 단위로 지정된 대형 메시지 큐 크기 제한을 통해 로드 성능이 향상 가능 https://www.ibm.com/docs/ko/db2/11.1?topic=unix-modifying-kernel-parameters-linux
echo "kernel.msgmnb = 65536" >> /etc/sysctl.conf
#  하나의 프로세스에서 다른 프로세스로 보내질 수 있는 최대 메시지 사이즈를 지정 기본설정 : 8192
echo "kernel.msgmax = 65536" >> /etc/sysctl.conf
# 최대 메시지 큐 식별자의 수를 지정 기본설정 : 16
echo "kernel.msgmni = 2878" >> /etc/sysctl.conf
# 세마포어 조정 https://www.ibm.com/docs/ko/ibm-mq/9.1?topic=linux-configuring-tuning-operating-system
echo "kernel.sem = 1000 32000 100 512" >> /etc/sysctl.conf
# 최대 공유 메모리 세그먼트 수
echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
# 최대 프로세스 ID 수
echo "kernel.pid_max = 65536" >> /etc/sysctl.conf
# 리눅스 커널이 열 수 있는 file handle 설정
echo "fs.file-max = 8000000" >> /etc/sysctl.conf
# 스왑메모리 활용 수준 조절  https://blog.naver.com/PostView.nhn?blogId=hanajava&logNo=221516060597
echo "vm.swappiness = 10" >> /etc/sysctl.conf
# 커널 매개변수 값 변경 -p : 파일 설정 상태 표시
sysctl -p

# SELinux도 해제 - > docker 실행시 에러 방지
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# firewalld 기능 비활성화
systemctl disable firewalld
# firewalld 중지
systemctl stop firewalld

# localtime 타임 변경
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtim