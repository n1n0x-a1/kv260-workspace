# _*_ coding: utf-8 _*_
import socket
import subprocess
from subprocess import Popen, PIPE, STDOUT
import struct
import json
import os

phone = socket.socket(socket.AF_INET,socket.SOCK_STREAM) #买手机
phone.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
phone.bind(('0.0.0.0',8082)) #绑定手机卡
phone.listen(5) #阻塞的最大数
print('start runing.....')
while True: #链接循环
    coon,addr = phone.accept() # 等待接电话
    print(coon,addr)
    while True: #通信循环
        # 收发消息
        cmd = coon.recv(1024) #接收的最大数
        print(cmd.decode('utf-8'))
        #cmd = cmd.decode('utf-8').split()
        print('接收的是：%s',cmd)
        str = cmd.decode('utf-8').split()
        if str[0] == 'scp':
            print('--scp files...')
            str[-1] = 'root@192.168.123.112:'+str[-1].strip()
            print(str)
            cmd_scp = "sshpass -p ninox123 "
            for i in str:
                cmd_scp = cmd_scp + i + ' '
            print(cmd_scp)
            with Popen(cmd_scp, shell=True, stdout=PIPE, stderr=STDOUT, bufsize=1, universal_newlines=True) as p:
                for line in p.stdout:
                    print(line)
                    coon.send(line.encode('utf-8'))
            break
        else:
            cmd = f""". /opt/vitis_ai/conda/etc/profile.d/conda.sh
                   conda activate vitis-ai-pytorch
                   {cmd.decode('utf-8')}"""
            with Popen(cmd, stdout=PIPE,shell=True ,stderr=STDOUT, bufsize=1, universal_newlines=True) as p:
                for line in p.stdout:
                    print(line)
                    coon.send(line.encode('utf-8'))
            break
    coon.close()
phone.close()
