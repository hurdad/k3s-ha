# helm-k3s-server Helm Chart

Run a highly available k3s server as a Kubernetes StatefulSet backed by an external datastore.

## Prerequisites

- Kubernetes cluster with enough nodes for the desired replica count
- Helm v3
- A persistent storage class (optional if you want PVCs for local state)

## Install

```sh
helm repo add local .
helm install helm-k3s-server ./ -n helm-k3s-server --create-namespace \
  --set token.value="<your-k3s-token>"
```

If you already have a Secret with the token, reference it instead:

```sh
helm install helm-k3s-server ./ -n helm-k3s-server --create-namespace \
  --set token.existingSecret.name="k3s-token" \
  --set token.existingSecret.key="token"
```

## Upgrade

```sh
helm upgrade helm-k3s-server ./ -n helm-k3s-server --set token.value="<your-k3s-token>"
```

## Uninstall

```sh
helm uninstall helm-k3s-server -n helm-k3s-server
```

## Configuration

| Key | Description | Default |
| --- | --- | --- |
| `replicaCount` | Number of k3s server replicas | `3` |
| `image.repository` | k3s image repository | `rancher/k3s` |
| `image.tag` | k3s image tag | `v1.34.3-k3s1` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `token.value` | Shared k3s server token (required) | `"super-secret-k3s-token"` |
| `token.existingSecret.name` | Use an existing Secret for the token | `""` |
| `token.existingSecret.key` | Key name in the existing Secret | `"token"` |
| `service.api.enabled` | Expose the Kubernetes API service | `true` |
| `service.api.type` | Service type for API | `ClusterIP` |
| `service.api.port` | API service port | `6443` |
| `service.api.annotations` | Service annotations | `{}` |
| `service.api.loadBalancerSourceRanges` | Allowed source ranges | `[]` |
| `service.api.externalTrafficPolicy` | External traffic policy | `Cluster` |
| `persistence.enabled` | Enable PVCs for local state | `true` |
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
| `healthChecks.enabled` | Enable container health checks | `true` |
| `healthChecks.liveness` | Liveness check settings | See `values.yaml` |
| `healthChecks.readiness` | Readiness check settings | See `values.yaml` |
| `healthChecks.startup.enabled` | Enable startup check | `true` |
| `healthChecks.startup` | Startup check settings | See `values.yaml` |
| `k3s.apiPort` | HTTPS port for the Kubernetes API server | `6443` |
| `k3s.debug` | Enable verbose k3s logging via `K3S_DEBUG` | `false` |
| `k3s.extraArgs` | Extra args for `k3s server` | `['--write-kubeconfig-mode=644']` |
| `k3s.datastore.endpoint` | External datastore endpoint (required) | `""` |
| `k3s.datastore.cafile` | Datastore TLS CA file path | `""` |
| `k3s.datastore.certfile` | Datastore TLS certificate file path | `""` |
| `k3s.datastore.keyfile` | Datastore TLS key file path | `""` |
| `k3s.tlsSANs` | Additional TLS SANs for the API server cert | `[]` |

## Notes

- Replace `token.value` with your own secure token; the chart stores it in a Kubernetes Secret.
- Prefer `token.existingSecret` in production so the token is never rendered into manifests or Helm release metadata.
- If you expose the API via a LoadBalancer, add the DNS name to `k3s.tlsSANs`.
- This chart requires `k3s.datastore.endpoint` (embedded etcd is not supported).
- Consider disabling `persistence.enabled` if you don't need local state.
