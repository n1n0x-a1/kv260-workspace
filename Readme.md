This project will explain the implementation of socket client server architecture. We will be using a k3s cluster environment with two servers setup, a normal computer server and a kv260 development board.

## Chapter 1: Conceptual Overview

In previous project, we create a model select application based on kv260 development board. In this demo we will extend the project functionality to include server client interaction. 

*We will create two nodes (master and worker).
And user can use command line interface to complete our goals. It can:*
1. Remotely modify bitstream.
2. Remotely quantize, compile, and deploy Vitis AI model to the target.
3. Remotely run model select application.

** Note remote here means under same network space if there is no applicable public ip configured

Below is the cluster setup diagram. Circle indicates it as a socket server. It will directly serve bitstream, ai model, and application service to client accordingly.

<img src="https://imgur.com/HRybfGo.jpg" width="300">

## Chapter 2: Setup K3s Cluster

We will have:
* Master/Worker node (Ubuntu20.04.3) on Proxmox VM
* Worker node (Petalinux 2022.1) on Kria-kv260

First on Proxmox server, we will set temporary pre-routing rule to nginx and kubectl route or you can add the rule in /etc/network:

(Suppose VM's ip is 10.20.0.109 and KV260's ip is 10.20.0.33)

```bash
$ iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 6443 -j DNAT --to 10.20.0.109

$ iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 8080 -j DNAT --to 10.20.0.109

$ iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 8082 -j DNAT --to 10.20.0.109

$ iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 8084 -j DNAT --to 10.20.0.33
```

### **On master node (VM)**:
We will install k3s without using traefik, which is the default router/load-balancer for k3s.

```bash
$ curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --bind-address 10.20.0.XXX" K3S_NODE_NAME=master sh -s -

$ export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

$ sudo chmod 777 /etc/rancher/k3s/k3s.yaml
```

### Remote kubectl (on your laptop):
First get kubectl command in your environment and copy and save /etc/rancher/k3s/k3s.yaml to your local KUBECONFIG path. Now you should be able to control the cluster from your laptop.

Next, deploy nginx
```bash
$ kubectl apply -k kv260-smartapp-clusterserver/nginx
```

### On KV260:

First we need to copy token from **master node** to enable additional node to be added to the cluster.
```bash
$ sudo cat /var/lib/rancher/k3s/server/node-token
```

Then on KV260 we will install a worker node on it with the token got.

```bash
$ curl -sfL https://get.k3s.io | K3S_NODE_NAME=worker K3S_TOKEN=<token> K3S_URL=https://<master_ip>:6443 sh - 
```

After all cluster connection are done, label each node so that we can deploy pods on the selected node
```bash
$ kubectl label node worker node-role.kubernetes.io/worker=worker

$ kubectl label node worker id=worker

$ kubectl label node master id=master
```

## Chapter 3: Pod and server deployment
Now we will actually bring up servers. There are three servers, all of which are implemented in python:

1. vitis-ai (pod on master)
2. xmutil (pod on kv260)
3. application (bare server on kv260)

**_We have tried to put application in pod, however, there will be problem occur and unresolved. Therefore it is temporary to run server directly on board._**

### Vitis-AI (On VM)
To deploy Vitis AI pod on master
```bash
## copy kv260-smartapp-clusterserver/need onto master
$ scp -r kv260-smartapp-clusterserver/need <vm-node>:~/

## copy arch.json for compilation
$ cp need/arch.json <path-to-Vitis-AI>

## copy .prototxt for new model that will later included when deploy model to the board
$ cp need/my_model.prototxt <path-to-Vitis-AI>

## copy dataset
$ cp -r need/ALLFORDEMO <path-to-Vitis-AI>

## replace new resnet18_quant.py
$ cp need/resnet18_quant.py <path-to-Vitis-AI>/src/Vitis-AI-Quantizer/vai_q_pytorch/example/

## copy socket server file
$ cp server/vitis-server.py <path-to-Vitis-AI>

## Modify vitis and work volume path to your Vitis AI

## Create some folder for vitis-deployment
$ mkdir /dev/shm

$ mkdir /opt/xilinx/overlaybins

$ mkdir /opt/xilinx/dsa

## Deploy
$ kubectl apply -f kv260-smartapp-clusterserver/deployment/vitis.yaml
```

### Xmutil (On KV260)
To deploy xmutil pod on kv260
```bash
## copy socket file to kv260
$ scp server/xmutil-server.py <kv260-node>:/home/petalinux/

## Deploy
$ kubectl apply -f kv260-smartapp-clusterserver/deployment/xmutil.yaml
```

### Application (On KV260)
To deploy application on kv260 baremetal
```bash
## copy socket file to kv260
$ scp server/app-server.py <kv260-node>:/opt/xilinx/kv260-vvas-sms/app

## Start the server
$ cd /opt/xilinx/kv260-vvas-sms/app

$ python app-server.py
```


## Chapter 4: Command line interface
We implement an easy to use command line interface in go. It will connect to the proxmox server (10.1.2.147).

We have docker file that you can use it for dev, build or production.

To run the application:

```bash
$ cd kv260-smartapp-cli

$ docker build --target prod . -t ninoctl

$ docker run -it ninoctl
```

Then you can use it.

To use it:

**ninoctl** [ **command** ] [ **argument** ]

command can be 
- bitstream
- model quantize
- model compile
- model deploy
- app

To find the argument, just type ninoctl -help for more information.
Note that for now model's argument are inconvenient for now. The path in the argument refers to relative path of where server in vitis-ai deployment is.

For example:

To quantize resnet 18 float model, we copy resnet18_quant.py to a certain path. Therefore -model_dir for model quantize should be src/Vitis-AI-Quantizer/vai_q_pytorch/example/

Since in Chapter 3 you copy vitis-server.py and arch.json under the same path. Therefore -a argument for model compile should be just arch.json.

After model deployed to the board, remember to fix the application to include the newly added model and recompile the c code, so you can test the model is working.