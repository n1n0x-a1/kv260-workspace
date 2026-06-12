#!/bin/bash
cd 00-gpu-slicing/

# Apply ConfigMap
kubectl apply -k .

# Install device plugin pointing to ConfigMap
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
helm repo update
helm install nvidia-device-plugin nvdp/nvidia-device-plugin \
  --namespace kube-system \
  --set config.name=nvidia-config \
  --set config.default=tesla-t400

cd ../01-metallb/
kubectl apply -k .
kubectl wait --for=condition=Established crd/ipaddresspools.metallb.io --timeout=60s
kubectl wait --for=condition=Established crd/l2advertisements.metallb.io --timeout=60s
kubectl wait --for=condition=Available deployment/controller -n metallb-system --timeout=60s
sleep 5

cd config/
kubectl apply -k .
cd ..

cd ../02-gateway-api/
kubectl apply -f namespace.yaml
helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm \
  --version v1.7.2 \
  --namespace envoy-gateway-system \
  --set deployment.envoyGateway.resources.requests.cpu=100m \
  --set deployment.envoyGateway.resources.requests.memory=256Mi \
  --wait
kubectl apply -k .
  
cd ../03-reflector/
kubectl apply -k .
cd ../04-cert-manager/
kubectl apply -k .
cd ../05-sealed-secret/
kubectl apply -k .
cd ../06-certificate-management/
kubectl apply -k .
cd ../07-storage-phase/rancher-local-path-provisioner/
kubectl apply -k .
cd ../../08-metrics-server/
kubectl apply -k .
