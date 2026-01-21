# k3s-ha Helm Chart

Run a highly available k3s server (embedded etcd) as a Kubernetes StatefulSet.

## Prerequisites

- Kubernetes cluster with enough nodes for the desired replica count
- Helm v3
- A persistent storage class (or set `persistence.enabled=false` to use emptyDir)

## Install

```sh
helm repo add local .
helm install k3s-ha ./ -n k3s-ha --create-namespace \
  --set token.value="<your-k3s-token>"
```

## Upgrade

```sh
helm upgrade k3s-ha ./ -n k3s-ha --set token.value="<your-k3s-token>"
```

## Uninstall

```sh
helm uninstall k3s-ha -n k3s-ha
```

## Configuration

| Key | Description | Default |
| --- | --- | --- |
| `replicaCount` | Number of k3s server replicas | `3` |
| `image.repository` | k3s image repository | `rancher/k3s` |
| `image.tag` | k3s image tag | `v1.29.7-k3s1` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `token.value` | Shared k3s server token (required) | `"super-secret-k3s-token"` |
| `service.api.enabled` | Expose the Kubernetes API service | `true` |
| `service.api.type` | Service type for API | `ClusterIP` |
| `service.api.port` | API service port | `6443` |
| `service.api.annotations` | Service annotations | `{}` |
| `service.api.loadBalancerSourceRanges` | Allowed source ranges | `[]` |
| `service.api.externalTrafficPolicy` | External traffic policy | `Cluster` |
| `serviceHeadless.port` | Headless service port | `6443` |
| `persistence.enabled` | Enable PVCs for embedded etcd | `true` |
| `persistence.size` | PVC size | `20Gi` |
| `persistence.storageClassName` | Storage class name | `""` |
| `persistence.accessModes` | PVC access modes | `[ReadWriteOnce]` |
| `securityContext.privileged` | Run the k3s server container privileged | `true` |
| `hostNetwork.enabled` | Enable host networking | `true` |
| `antiAffinity.enabled` | Spread pods across nodes | `true` |
| `resources` | Pod resources | `{}` |
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `affinity` | Pod affinity rules | `{}` |
| `k3s.extraArgs` | Extra args for `k3s server` | `['--write-kubeconfig-mode=644']` |
| `k3s.tlsSANs` | Additional TLS SANs for the API server cert | `[]` |

## Notes

- Replace `token.value` with your own secure token or template it from a Secret.
- If you expose the API via a LoadBalancer, add the DNS name to `k3s.tlsSANs`.
