# K8s Infrastructure Setup

> Updated 2026/06/05 by [@evanzzer](https://github.com/evanzzer)

This guide covers bootstrapping a Kubernetes cluster from scratch — initializing the
master node, joining workers, and deploying all infrastructure components in order.

The cluster uses **Cilium** as a full `kube-proxy` replacement (eBPF-based networking),
**Envoy Gateway** for ingress, **cert-manager** for TLS, and **local-path** for storage.

---

## Prerequisites

All nodes must already be provisioned and reachable via SSH. This should be fully handled by [Terraform](../initialization/README.md#phase-2-terraform-configuration).

---

## Phase 1: Cluster Initialization

Run all commands in this phase on the **master node** unless stated otherwise.

### Step 1 — Initialize the Master Node

Skip `kube-proxy` so Cilium can manage all traffic via eBPF:

```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=<MASTER_IP> \
  --skip-phases=addon/kube-proxy
```

Set up kubeconfig:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

> [!CAUTION]
> Not Recommended Action. This allows workloads to schedule on the master node:
>
> ```bash
> kubectl taint nodes master node-role.kubernetes.io/control-plane:NoSchedule-
> ```

---

## Phase 2: Join Worker Nodes

Run on each **worker node**, using the token and hash from the `kubeadm init` output above.

### Standard Workers

```bash
sudo kubeadm join master-1.ninox.com:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
```

Or join all workers at once via SSH (if DNS is configured):

```bash
for node in worker-infra-{1..2}.ninox.com; do
  ssh -o StrictHostKeyChecking=accept-new k8s@$node "sudo kubeadm join master.ninox.com:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
done
for node in worker-{1..3}.ninox.com; do
  ssh -o StrictHostKeyChecking=accept-new k8s@$node "sudo kubeadm join master.ninox.com:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
done
```

### GPU Worker

Configure the NVIDIA container runtime **before** joining:

```bash
sudo nvidia-ctk runtime configure --runtime=containerd --set-as-default
sudo systemctl restart containerd

sudo kubeadm join master.ninox.com:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
```

After the GPU worker has joined, label and taint it from the **master node**:

```bash
kubectl label node worker-gpu nvidia.com/gpu.present=true hardware=nvidia-t400
kubectl taint node worker-gpu nvidia.com/gpu=present:NoSchedule
```

### Configure Application Workers

Configure selected worker containers to label and taint as an application worker in **master node**, separating it from infrastructure worker.

```bash
kubectl label node <worker-node> workload=app
kubectl taint node <worker-node> workload=app:NoSchedule
```

You can use the command below at once (if DNS server is configured):

```bash
for node in worker-{1..3}; do
  kubectl label node $node workload=app
  kubectl taint node $node workload=app:NoSchedule
done
```

Future deployment for application workers must include the following configuration:

```yaml
      nodeSelector:
        workload: app
      tolerations:
        - key: workload
          value: app
          effect: NoSchedule
```

---

## Phase 3: Tools Installation

Run all commands in this phase on the **master node** for tools installation.

### Step 1 — Install Cilium

```bash
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-amd64.tar.gz
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz

# Install with Hubble UI and relay
cilium install --set hubble.relay.enabled=true --set hubble.ui.enabled=true

# Pin to master node address
cilium upgrade --set k8sServiceHost=192.168.123.210 --set k8sServicePort=6443
```

---

### Step 2 — Install Helm `v4.1.4`

```bash
curl -fsSL https://get.helm.sh/helm-v4.1.4-linux-amd64.tar.gz -o helm.tar.gz
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf helm.tar.gz linux-amd64
```

---

## Phase 4: Infrastructure Components

For quick deployment, run the automated script from the `k8s-infra/` directory:

```bash
./deployinfra.sh
```

For easier troubleshooting or step-by-step control, follow the manual steps below.
Each step links to its own readme with more detail.

---

### 00 — GPU Slicing [`00-gpu-slicing/`](./00-gpu-slicing/readme.md)

> `nvidia-device-plugin v0.17.0`, `k8s-device-plugin` Helm chart

Configures time-slicing for the T400 GPU so multiple pods can share it:

```bash
cd 00-gpu-slicing/
kubectl apply -k .
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
helm repo update
helm install nvidia-device-plugin nvdp/nvidia-device-plugin \
  --namespace kube-system \
  --set config.name=nvidia-config \
  --set config.default=tesla-t400
```

---

### 01 — Metal Load Balancer [`01-metallb/`](./01-metallb/readme.md)

> `MetalLB v0.15.3`

Provides LoadBalancer IP assignment for bare-metal nodes:

```bash
cd 01-metallb/
kubectl apply -k .
kubectl wait --for=condition=Established crd/ipaddresspools.metallb.io --timeout=60s
kubectl wait --for=condition=Established crd/l2advertisements.metallb.io --timeout=60s
kubectl wait --for=condition=Available deployment/controller -n metallb-system --timeout=60s

# Apply IP pool and L2 advertisement config
cd config/ && kubectl apply -k . && cd ..
```

---

### 02 — Gateway API / Envoy Gateway [`02-gateway-api/`](./02-gateway-api/readme.md)

> Envoy Gateway `v1.7.2`

Installs the Gateway API CRDs and Envoy Gateway as the ingress controller:

```bash
cd 02-gateway-api/
kubectl apply -f namespace.yaml
helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm \
  --version v1.7.2 \
  --namespace envoy-gateway-system \
  --set deployment.envoyGateway.resources.requests.cpu=100m \
  --set deployment.envoyGateway.resources.requests.memory=256Mi \
  --wait
kubectl apply -k .
```

---

### 03 — Reflector [`03-reflector/`](./03-reflector/readme.md)

> `reflector 10.0.39`

Mirrors secrets and configmaps across namespaces. Required so the wildcard TLS secret
issued in `cert-manager` can be consumed by services in other namespaces (e.g. `gitlab`, `harbor-system`):

```bash
cd 03-reflector/
kubectl apply -k .
```

---

### 04 — Certificate Manager [`04-cert-manager/`](./04-cert-manager/readme.md)

> `cert-manager v1.20.2`

Installs cert-manager for automatic TLS certificate issuance:

```bash
cd 04-cert-manager/
kubectl apply -k .
```

> [!IMPORTANT]
> `cert-manager` is installed via `kubectl apply`, **not** Helm. This means its CRDs are
> not managed by Helm. Services that bundle their own `cert-manager` (e.g. GitLab) must
> have their bundled `cert-manager` disabled to avoid CRD ownership conflicts.

---

### 05 — Sealed Secrets [`05-sealed-secret/`](./05-sealed-secret/readme.md)

> Sealed Secrets `v0.37.0`

Installs the Sealed Secrets controller so encrypted secrets can be safely committed to Git:

```bash
cd 05-sealed-secret/
kubectl apply -k .
```

---

### 06 — Certificate Management [`06-certificate-management/`](./06-certificate-management/readme.md)

Creates `ClusterIssuers` and the wildcard certificate for `*.ninox.com`. Depends on Reflector ([Step 03](#03--reflector-03-reflector)) and cert-manager ([Step 04](#04--certificate-manager-04-cert-manager)):

```bash
cd 06-certificate-management/
kubectl apply -k .
```

---

### 07 — Storage

Sets up the default `StorageClass` for the cluster. Two options are available:

---

#### Option A — NFS (recommended) [`nfs-provisioner/`](./07-storage-phase/nfs-provisioner/README.md)

> `nfs-subdir-external-provisioner v4.0.18`

Backed by a ZFS mirror pool on the Proxmox host. Requires NFS server setup on the host first — see the README.

```bash
helm repo add nfs-subdir-external-provisioner \
  https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

helm install nfs-provisioner \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace nfs --create-namespace \
  --set nfs.server=<proxmox-host-ip> \
  --set nfs.path=/mnt/nfs/k8s \
  --set storageClass.name=nfs \
  --set storageClass.defaultClass=true
```

---

#### Option B — Local Path [`rancher-local-path-provisioner/`](./07-storage-phase/rancher-local-path-provisioner/README.md)

> `local-path-provisioner v0.0.35`

Backed by node-local storage. Simpler setup but no redundancy.

```bash
cd 07-storage-phase/rancher-local-path-provisioner/
kubectl apply -k .
```

---

### 08 - Metrics Server [`08-metrics-server/`](./08-metrics-server/readme.md)

> `metrics-server 0.8.1`

This is to give information about resource consumption for each pods. To install the metrics server:

```bash
cd 08-metrics-server/
kubectl apply -k .
```

---

## Phase 5: Certificate Deployment

The wildcard certificate issued in Phase 3 step 06 must be distributed to all nodes
so services can trust it. Without this, you will see `x509: certificate signed by unknown authority` errors.

### Step 1 — Export the CA from the cluster

```bash
kubectl get secret ingress-cert-tls -n cert-manager \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > ninox-ca.crt
```

### Step 2 — Copy the certificate to the Proxmox host

```bash
scp ninox-ca.crt root@<proxmox-ip>:/root/path/to/terraform/
```

### Step 3 — Distribute to all VMs via Terraform

Using [`ca_dist.tf`](../initialization/terraform/ca_dist.tf):

```bash
cd /root/path/to/terraform
terraform apply -target=null_resource.ca_dist
```

This installs `ninox-ca.crt` into the system trust store on every node and configures
Docker/containerd to trust it for `harbor.ninox.com` image pulls. Re-run whenever the cert renews.

---

## Verification

```bash
# All nodes should be Ready
kubectl get nodes

# All infra pods should be Running
kubectl get pods -A

# Cilium health check
cilium status
cilium connectivity test
```

---

## Troubleshooting

### Token expired for worker join

`kubeadm` tokens expire after 24 hours. Generate a new one on the master:

```bash
kubeadm token create --print-join-command
```

### Cilium not ready after install

Wait for all Cilium pods to be running before deploying any other components:

```bash
kubectl rollout status daemonset/cilium -n kube-system
```
