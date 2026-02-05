# sourcebot

![Version: 0.1.33](https://img.shields.io/badge/Version-0.1.33-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v4.10.26](https://img.shields.io/badge/AppVersion-v4.10.26-informational?style=flat-square)

Sourcebot is a self-hosted tool that helps you understand your codebase.

**Homepage:** <https://sourcebot.dev/>

## Source Code

* <https://github.com/sourcebot-dev/sourcebot>
* <https://github.com/sourcebot-dev/sourcebot/kubernetes/chart>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.4.9 |
| oci://registry-1.docker.io/bitnamicharts | redis(valkey) | 2.2.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Override the full name of the deployed resources, defaults to a combination of the release name and the name for the selector labels |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.security.allowInsecureImages | bool | `true` | Allow insecure images to use bitnami legacy repository. Can be set to false if secure images are being used (Paid). |
| nameOverride | string | `""` | Override the name for the selector labels, defaults to the chart name |
| postgresql.auth.args | string | `""` | Additional database connection arguments |
| postgresql.auth.database | string | `"sourcebot"` | Database name |
| postgresql.auth.existingSecret | string | `""` | Use an existing secret for PostgreSQL password |
| postgresql.auth.password | string | `""` | Password for PostgreSQL user (only used if existingSecret is not set) |
| postgresql.auth.secretKeys | object | `{"adminPasswordKey":"postgresql-password","userPasswordKey":"postgresql-password"}` | Keys in the existing secret |
| postgresql.auth.username | string | `"sourcebot"` | Username to connect to PostgreSQL |
| postgresql.deploy | bool | `true` | Deploy PostgreSQL subchart. Set to false to use an external PostgreSQL instance. |
| postgresql.host | string | `""` | PostgreSQL host (only used if deploy is false) |
| postgresql.image.repository | string | `"bitnamilegacy/postgresql"` | Overwrite default repository of helm chart to point to non-paid bitnami images |
| postgresql.port | int | `5432` | PostgreSQL port |
| postgresql.primary.persistence.enabled | bool | `true` |  |
| postgresql.primary.persistence.size | string | `"8Gi"` |  |
| redis.auth.database | int | `0` | Redis database number |
| redis.auth.existingSecret | string | `""` | Use an existing secret for Redis password |
| redis.auth.existingSecretPasswordKey | string | `"redis-password"` | Key in the existing secret that contains the Redis password |
| redis.auth.password | string | `""` | Password for Redis user (only used if existingSecret is not set) |
| redis.auth.username | string | `"default"` | Username for Redis connection |
| redis.deploy | bool | `true` | Deploy Redis/Valkey subchart. Set to false to use an external Redis instance. |
| redis.host | string | `""` | Redis host (only used if deploy is false) |
| redis.image.repository | string | `"bitnamilegacy/valkey"` | Overwrite default repository of helm chart to point to non-paid bitnami images |
| redis.port | int | `6379` | Redis port |
| sourcebot.additionalEnv | list | `[]` | Set additional environment variables |
| sourcebot.additionalEnvSecrets | list | `[]` | Set environment variables from Kubernetes secrets |
| sourcebot.additionalLabels | object | `{}` | Add extra labels to all resources |
| sourcebot.additionalPorts | list | `[]` | Configure additional ports to expose on the container and service |
| sourcebot.affinity | object | `{}` | Set affinity rules for pod scheduling Defaults to soft anti-affinity if not set See: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/ |
| sourcebot.args | list | `[]` | Override the default arguments of the container |
| sourcebot.command | list | `[]` | Override the default command of the container |
| sourcebot.config | object | `{"$schema":"https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json","connections":{},"settings":{}}` | Configure Sourcebot-specific application settings |
| sourcebot.containerSecurityContext | object | `{}` | Set the container-level security context |
| sourcebot.envFrom | list | `[]` | Load environment variables from ConfigMaps and Secrets This is useful for injecting multiple environment variables from external secret management systems |
| sourcebot.extraVolumeMounts | list | `[]` | Define volume mounts for the container See: https://kubernetes.io/docs/concepts/storage/volumes/ |
| sourcebot.extraVolumes | list | `[]` | Define additional volumes See: https://kubernetes.io/docs/concepts/storage/volumes/ |
| sourcebot.image.digest | string | `""` | Container image digest (used instead of tag if set) |
| sourcebot.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| sourcebot.image.pullSecrets | list | `[]` | Configure image pull secrets for private registries |
| sourcebot.image.repository | string | `"ghcr.io/sourcebot-dev/sourcebot"` | Container image repository |
| sourcebot.image.tag | string | `""` | Container image tag. Falls back to appVersion if not set. |
| sourcebot.ingress.annotations | object | `{}` | Ingress annotations |
| sourcebot.ingress.className | string | `""` | Ingress class name |
| sourcebot.ingress.enabled | bool | `false` | Enable or disable ingress |
| sourcebot.ingress.hosts | list | `[]` | List of hostnames and paths for ingress rules. The first host will be used as the default host. |
| sourcebot.ingress.tls | list | `[]` | TLS settings for ingress |
| sourcebot.initContainers | list | `[]` | Configure init containers to run before the main container |
| sourcebot.license.existingSecret | string | `""` | Use an existing secret for the license key |
| sourcebot.license.existingSecretKey | string | `"key"` | Key in the existing secret that contains the license key |
| sourcebot.license.value | string | `""` | License key value (or use existingSecret) |
| sourcebot.livenessProbe.failureThreshold | int | `5` | Number of consecutive failures before marking the container as unhealthy |
| sourcebot.livenessProbe.httpGet | object | `{"path":"/api/health","port":"http"}` | Http GET request to check if the container is alive |
| sourcebot.livenessProbe.httpGet.path | string | `"/api/health"` | Path to check |
| sourcebot.livenessProbe.httpGet.port | string | `"http"` | Port to check |
| sourcebot.livenessProbe.initialDelaySeconds | int | `20` | Initial delay before the first probe |
| sourcebot.livenessProbe.periodSeconds | int | `10` | Frequency of the probe |
| sourcebot.nodeSelector | object | `{}` | Set node selector constraints See: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector |
| sourcebot.persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for the persistent volume |
| sourcebot.persistence.annotations | object | `{}` | Annotations for the PersistentVolumeClaim |
| sourcebot.persistence.enabled | bool | `true` | Enable persistent storage for repository data and search indexes |
| sourcebot.persistence.existingClaim | string | `""` | Use an existing PersistentVolumeClaim (if set, other persistence settings are ignored) |
| sourcebot.persistence.size | string | `"10Gi"` | Size of the persistent volume |
| sourcebot.persistence.storageClass | string | `""` | Storage class name. If not set, uses the cluster default storage class |
| sourcebot.podAnnotations | object | `{}` | Add annotations to the pod metadata |
| sourcebot.podDisruptionBudget.enabled | bool | `true` | Enable Pod Disruption Budget |
| sourcebot.podDisruptionBudget.maxUnavailable | int | `1` | Maximum number of pods that can be unavailable |
| sourcebot.podDisruptionBudget.minAvailable | int | `1` | Minimum number of pods that must be available |
| sourcebot.podSecurityContext | object | `{"fsGroup":1500,"runAsGroup":1500,"runAsNonRoot":true,"runAsUser":1500}` | Set the pod-level security context |
| sourcebot.priorityClassName | string | `""` | Set the priority class name for pods See: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/ |
| sourcebot.readinessProbe.failureThreshold | int | `5` | Number of consecutive failures before marking the container as not ready |
| sourcebot.readinessProbe.httpGet | object | `{"path":"/api/health","port":"http"}` | Http GET request to check if the container is ready |
| sourcebot.readinessProbe.httpGet.path | string | `"/api/health"` | Path to check |
| sourcebot.readinessProbe.httpGet.port | string | `"http"` | Port to check |
| sourcebot.readinessProbe.initialDelaySeconds | int | `20` | Initial delay before the first probe |
| sourcebot.readinessProbe.periodSeconds | int | `10` | Frequency of the probe |
| sourcebot.replicaCount | int | `1` | Set the number of replicas for the deployment |
| sourcebot.resources | object | `{}` | Configure resource requests and limits for the container |
| sourcebot.service.annotations | object | `{}` | Service annotations |
| sourcebot.service.containerPort | int | `3000` | Internal container port |
| sourcebot.service.port | int | `3000` | External service port |
| sourcebot.service.type | string | `"ClusterIP"` | Type of the Kubernetes service (e.g., ClusterIP, NodePort, LoadBalancer) |
| sourcebot.serviceAccount.annotations | object | `{}` | Add annotations to the ServiceAccount |
| sourcebot.serviceAccount.automount | bool | `false` | Enable or disable automatic ServiceAccount mounting |
| sourcebot.serviceAccount.create | bool | `true` | Create a new ServiceAccount |
| sourcebot.serviceAccount.name | string | `""` | Use an existing ServiceAccount (if set) |
| sourcebot.startupProbe.failureThreshold | int | `30` | Number of seconds to wait before starting the probe |
| sourcebot.startupProbe.httpGet | object | `{"path":"/api/health","port":"http"}` | Http GET request to check if the container has started |
| sourcebot.startupProbe.httpGet.path | string | `"/api/health"` | Path to check |
| sourcebot.startupProbe.httpGet.port | string | `"http"` | Port to check |
| sourcebot.startupProbe.periodSeconds | int | `30` | Initial delay before the first probe |
| sourcebot.tolerations | list | `[]` | Set tolerations for pod scheduling See: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/ |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
