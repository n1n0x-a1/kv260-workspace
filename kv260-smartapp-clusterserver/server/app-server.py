# _*_ coding: utf-8 _*_
import socket
import subprocess
from subprocess import Popen, PIPE, STDOUT
import signal,os
import atexit
import multiprocessing
import sys
from threading import Thread
from queue import Queue, Empty

ON_POSIX = 'posix' in sys.builtin_module_names

def exit_handler():
    active = multiprocessing.active_children()
    for child in active:
        child.terminate()

atexit.register(exit_handler)

def enqueue_output(out, queue):
    for line in out:
        queue.put(line)
    out.close()

def recieve_signal(con, queue):
    signal = True
    while signal:
        try:
            signal = con.recv(1024).decode('utf-8')
            queue.put(signal)
        except:
            con.close()

phone = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
phone.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
phone.bind(('0.0.0.0',31219))
phone.listen(5)
print('start runing.....')
my_env = os.environ.copy()
while True:
    coon,addr = phone.accept()
    print(coon,addr)
    cmd = coon.recv(1024)
    cmd = cmd.decode('utf-8') #.split()
    print('接收的是：%s',cmd)
    tmp_cmd = cmd
    if cmd.split()[0] == "source":
        cmd = cmd + " && env"
        print(cmd)
    p = subprocess.Popen(cmd, env=my_env, shell=True, stdout=PIPE,stdin=PIPE, stderr=STDOUT, bufsize=1, text=True, preexec_fn=os.setpgrp, 
close_fds=ON_POSIX)
    q = Queue()
    t = Thread(target=enqueue_output, args=(p.stdout, q))
    t.daemon = True
    t.start()

    r = Queue()
    s = Thread(target=recieve_signal, args=(coon, r))
    s.daemon = True
    s.start()

    while True:
        # read line without blocking
        try:
            line = q.get_nowait()
        except Empty:
            try:
                while q.empty():
                    try: rec = r.get_nowait()
                    except Empty:
                        coon.send("~".encode('utf-8'))
                    else:
                        print('Get: ', rec[:-1])
                        p.stdin.write(rec)
            except:
                os.killpg(os.getpgid(p.pid), signal.SIGTERM)
                break
        else:
            try:
                coon.send(line.encode('utf-8'))
                try: rec = r.get_nowait()
                except Empty:
                    if tmp_cmd.split()[0] == "source":
                        (key, _, value)=line.partition("=")
                        my_env[key] = value[:-1]
                else:
                    print(rec)
            except:
                os.killpg(os.getpgid(p.pid), signal.SIGTERM)
                break
    print("close connection")
    coon.close()
phone.close()
