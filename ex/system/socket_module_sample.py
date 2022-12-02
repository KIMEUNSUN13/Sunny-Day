#!/bin/env python
#-*- coding: utf-8 -*-

import socket

host = socket.gethostbyname_ex("www.google.com")

print("--------- host --------")
print(host)

print("\n--------- host_--------")
for i in host:
    print(i)

hostname, aliaslist, ipaddrlist = host
print("\n--------- ipaddrlist --------")
print("ip: ", ipaddrlist[0])