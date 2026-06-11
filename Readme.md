This project will explain the implementation of socket client server architecture. 

We will be using a KubeEdge cluster environment with a Master Node (CloudCore) and a Kria KV260 Edge Node (EdgeCore).

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

## Chapter 2: Setup KubeEdge Cluster

We will have:
* Cloud Node / Master: A standard Kubernetes cluster control plane (e.g., initialized via kubeadm) running on a Proxmox VM (Ubuntu 20.04/22.04/24.04).
* Edge Node: Kria KV260 board running custom PetaLinux containing KubeEdge (`edgecore`).

Because KubeEdge uses an outbound WebSocket/QUIC tunnel from the edge to the master, **no inbound port-forwarding or dynamic NAT prerouting rules are required on the KV260 side.**

### **On the Master Node (Proxmox VM)**:
1. Ensure your Kubernetes cluster control plane is running.
2. Initialize KubeEdge `cloudcore` via `keadm`:
   ```bash
   $ keadm init --advertise-address=<VM_IP> --profile version=v1.15.0
   ```
3. Retrieve the cloudcore token required for joining edge nodes:
   ```bash
   $ keadm gettoken
   ```

### Remote kubectl (on your laptop):
Copy your Kubernetes kubeconfig file (e.g., `/etc/kubernetes/admin.conf` or standard K8s config) to your local `~/.kube/config`. You can now monitor and orchestrate the cluster using standard `kubectl` commands.

Next, deploy the ingress controller:
```bash
$ kubectl apply -k kv260-smartapp-clusterserver/nginx
```

### On the KV260:
1. Boot the KV260 using the custom Yocto/PetaLinux image compiled with `kubeedge` support.
2. Join the node to the master using the token retrieved from `cloudcore`:
   ```bash
   $ keadm join --cloudcore-ipport=<VM_IP>:10000 --token=<TOKEN> --kubeedge-version=v1.15.0
   ```
3. Verify that the edge node successfully registered by running this on your laptop or VM:
   ```bash
   $ kubectl get nodes
   ```
4. Label the node so that workloads deploy on it:
   ```bash
   $ kubectl label node <kv260-node-name> node-role.kubernetes.io/edge=""
   ```

---

## Chapter 3: Pod and server deployment

Now we will bring up the cloud and edge servers. There are three components:

1. **vitis-ai** (pod on VM/Master): Handles model compilation and quantization.
2. **xmutil** (pod on KV260): Handles dynamic FPGA bitstream swaps.
3. **application** (pod on KV260): Executes the AI model camera selection application.

*Note: In previous implementations, the application could not run inside a pod. This has been resolved under KubeEdge by running the pod in **privileged mode** and mounting the host `/dev` and `/sys` nodes.*

### Vitis-AI (On VM/Master Node)
To deploy the Vitis AI compiler pod:
```bash
## copy dependencies onto master VM
$ scp -r kv260-smartapp-clusterserver/need <vm-node>:~/

## copy arch.json, custom configs, and datasets
$ cp need/arch.json <path-to-Vitis-AI>
$ cp need/my_model.prototxt <path-to-Vitis-AI>
$ cp -r need/ALLFORDEMO <path-to-Vitis-AI>
$ cp need/resnet18_quant.py <path-to-Vitis-AI>/src/Vitis-AI-Quantizer/vai_q_pytorch/example/
$ cp server/vitis-server.py <path-to-Vitis-AI>

## Create necessary host volumes for deployment
$ mkdir /dev/shm
$ mkdir /opt/xilinx/overlaybins
$ mkdir /opt/xilinx/dsa

## Deploy Vitis AI compiler pod
$ kubectl apply -f kv260-smartapp-clusterserver/deployment/vitis-ai.yaml
```

### Xmutil (On KV260 Node)
To deploy the hardware overlay manager pod:
```bash
## copy socket script to KV260
$ scp server/xmutil-server.py <kv260-node>:/home/petalinux/

## Deploy the privileged pod to KubeEdge
$ kubectl apply -f kv260-smartapp-clusterserver/deployment/xmutil.yaml
```

### Application (On KV260 Node)
To deploy the containerized camera and DPU application:
```bash
## copy application script to KV260
$ scp server/app-server.py <kv260-node>:/opt/xilinx/kv260-vvas-sms/app

## Deploy the privileged application pod to KubeEdge
$ kubectl apply -f kv260-smartapp-clusterserver/deployment/app-pod.yaml
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
