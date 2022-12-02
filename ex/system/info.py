#!/usr/bin/env python
#-*- coding: utf-8 -*-

import platform # 운영체제의 환경 정보
import multiprocessing #CPU 개수

print('운영체제: ', platform.system())
print('운영체제의 상세정보: ', platform.platform())
print('운영체제 버전: ', platform.version())
print('프로세서: ', platform.processor())
print('CPU 수: ', multiprocessing.cpu_count())

