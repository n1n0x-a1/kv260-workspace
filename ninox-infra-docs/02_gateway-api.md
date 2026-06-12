# Gateway API / Envoy Gateway

> Updated 2026/05/12 by [@evanzzer](https://github.com/evanzzer)  
> Envoy Gateway `v1.7.2`

Replaces nginx ingress with **Envoy Gateway** using the Kubernetes Gateway API.
`kubernetes.io` officially recommends Gateway API as the successor to Ingress.

## Resources Functionality

| Resource | Purpose |
| --- | --- |
| `namespace.yaml` | `envoy-gateway-system` namespace |
| `gateway-class.yaml` | `GatewayClass/envoy` — registers the controller |
| `gateway.yaml` | `Gateway/ninox-gateway` — listeners on 80, 443 (TLS terminate) |
| `envoy-proxy-config.yaml` | `EnvoyProxy` — sets the auto-generated Service to `LoadBalancer` so MetalLB assigns an IP |
| `http-route-redirect.yaml` | HTTP → HTTPS redirect for all hosts |

## Prerequisites

- MetalLB installed and IP pool configured ([`01-metallb`](../01-metallb/readme.md))

---

## Installation

```bash
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

## Verification

```bash
# Envoy Gateway pods should be Running
kubectl get pods -n envoy-gateway-system

# MetalLB should have assigned an external IP to the gateway service
kubectl get svc -n envoy-gateway-system
```

---

## Adding routes for other services

Create an `HTTPRoute` in the service's own namespace referencing `ninox-gateway`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: my-service
  namespace: my-namespace
spec:
  parentRefs:
    - name: ninox-gateway
      namespace: envoy-gateway-system
      sectionName: https
  hostnames:
    - myservice.ninox.com
  rules:
    - backendRefs:
        - name: my-service-svc
          port: 8080
```
