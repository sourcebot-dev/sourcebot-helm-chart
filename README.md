# Sourcebot Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/sourcebot)](https://artifacthub.io/packages/search?repo=sourcebot)

Sourcebot is a self-hosted tool that helps you understand your codebase. This repository contains the official helm chart for deploying Sourcebot onto a Kubernetes cluster.

**Homepage:** <https://sourcebot.dev/>

## Introduction

This chart bootstraps a Sourcebot deployment on a Kubernetes cluster using the Helm package manager.

By default, this chart deploys:
- Sourcebot application
- PostgreSQL database (via Bitnami subchart)
- Redis/Valkey cache (via Bitnami subchart)

See the [minimal installation example](./examples/minimal-installation/) for a example deployment.

## Installation

1. Create a [config.json](https://docs.sourcebot.dev/docs/configuration/config-file) to configure repositories, language models, SSO identity providers, etc.
```jsonc
{
    "$schema": "https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json",
    "connections": {
        "github-repos": {
            "type": "github",
            "repos": [
                "sourcebot-dev/sourcebot"
            ]
        }
    }
}
```

2. Create a `values.yaml` file to configure the required configuration options:
```yaml
sourcebot:
  authSecret:
    value: "CHANGEME"   # generate via: openssl rand -base64 33
  encryptionKey:
    value: "CHANGEME"   # generate via: openssl rand -base64 24

postgresql:
  auth:
    password: "CHANGEME"

redis:
  auth:
    password: "CHANGEME"
```

They can alternatively be set via [secrets](https://kubernetes.io/docs/concepts/configuration/secret) (the secrets must exist):
```yaml
sourcebot:
  authSecret:
    existingSecret: sourcebot-secrets
    existingSecretKey: authSecret
  encryptionKey:
    existingSecret: sourcebot-secrets
    existingSecretKey: encryptionKey

postgresql:
  auth:
    existingSecret: sourcebot-secrets
    secretKeys:
      userPasswordKey: password
      adminPasswordKey: postgres-password

redis:
  auth:
    existingSecret: sourcebot-secrets
    existingSecretPasswordKey: redis-password
```

3. Install & deploy the chart:
```bash
helm repo add sourcebot https://sourcebot-dev.github.io/sourcebot-helm-chart
helm repo update
helm install sourcebot sourcebot/sourcebot \
  -f values.yaml \
  --set-json "sourcebot.config=$(cat config.json)"
```

## Upgrading

```bash
helm repo update
helm upgrade sourcebot sourcebot/sourcebot \
  -f values.yaml \
  --set-json "sourcebot.config=$(cat config.json)"
```

## Sizing

By default, the chart will run with the minimum resources to provide a stable experience. For production environments, we recommend to adjust the following parameters in the values.yaml.

```yaml
sourcebot:
  resources:
    requests:
      cpu: "2"
      memory: 4Gi
    limits:
      cpu: "2"
      memory: 4Gi

postgresql:
  primary:
    resources:
      requests:
        cpu: "2"
        memory: 4Gi
      limits:
        cpu: "2"
        memory: 4Gi

redis:
  primary:
    resources:
      requests:
        cpu: "1"
        memory: "1.5Gi"
      limits:
        cpu: "1"
        memory: "1.5Gi"
```

## App configuration

Sourcebot is configured via a JSON [config file](https://docs.sourcebot.dev/docs/configuration/config-file#config-file) as well as [environment variables](https://docs.sourcebot.dev/docs/configuration/environment-variables).

### config.json
For the config file, it is recommended to create a separate `config.json` and use `--set-json` on the [helm install](https://helm.sh/docs/helm/helm_install/) command:

```jsonc
// config.json
{
    "$schema": "https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json",
    "connections": {
        "github-repos": {
            "type": "github",
            "repos": [
                "sourcebot-dev/sourcebot"
            ]
        }
    }
}
```

```bash
helm install sourcebot sourcebot/sourcebot \
  -f values.yaml \
  --set-json "sourcebot.config=$(cat config.json)"
```

Alternatively, you can define the config directly in a `values.yaml` file:

```yaml
sourcebot:
  config:
    $schema: https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json
    connections:
      github-repos:
        type: github
        repos:
          - sourcebot-dev/sourcebot
```

### Environment variables

Environment variables are used to pass secrets to the `config.json` as well as to configure other options. See the [environment variables docs](https://docs.sourcebot.dev/docs/configuration/environment-variables) for a full list of supported variables.

For sensitive values, use `additionalEnvSecrets` to reference keys in an existing Kubernetes Secret:

```yaml
sourcebot:
  additionalEnvSecrets:
    - envName: GITHUB_TOKEN
      secretName: sourcebot-secrets
      secretKey: github-token
    - envName: ANTHROPIC_API_KEY
      secretName: sourcebot-secrets
      secretKey: anthropic-api-key
```

For non-sensitive values, use `additionalEnv`:

```yaml
sourcebot:
  additionalEnv:
    - name: SOURCEBOT_LOG_LEVEL
      value: "debug"
```

You can also mount entire Secrets or ConfigMaps using `envFrom`:

```yaml
sourcebot:
  envFrom:
    - secretRef:
        name: my-env-secrets
```

### License Key

To enable Enterprise Edition features, set your license key directly:

```yaml
sourcebot:
  license:
    value: "your-license-key"
```

Or via an existing secret:

```yaml
sourcebot:
  license:
    existingSecret: sourcebot-secrets
    existingSecretKey: license-key
```

## Persistence

Each component has its own persistent volume for storing data across pod restarts.

### Sourcebot

Stores cloned repositories and search indexes. Enabled by default with a 10Gi volume.

```yaml
sourcebot:
  persistence:
    enabled: true    # Default
    size: 10Gi       # Increase for large or many repositories
    storageClass: "" # Uses cluster default
    accessModes:
      - ReadWriteOnce
```

To use an existing [persistent volume claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) (PVC):

```yaml
sourcebot:
  persistence:
    existingClaim: my-existing-pvc
```

### PostgreSQL

Managed by the [Bitnami PostgreSQL subchart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql). Enabled by default with an 8Gi volume.

```yaml
postgresql:
  primary:
    persistence:
      enabled: true
      size: 8Gi
      storageClass: ""
```

### Redis

Managed by the [Bitnami Valkey subchart](https://github.com/bitnami/charts/tree/main/bitnami/valkey). Enabled by default with an 8Gi volume.

```yaml
redis:
  primary:
    persistence:
      enabled: true
      size: 8Gi
      storageClass: ""
```

## Examples

### Using an external Postgres server

```yaml
postgresql:
  deploy: false
  host: your-postgres-host.example.com
  port: 5432
  auth:
    username: sourcebot
    database: sourcebot
    existingSecret: sourcebot
    secretKeys:
      userPasswordKey: password
```

### Using an external Redis server

```yaml
redis:
  deploy: false
  host: your-redis-host.example.com
  port: 6379
  auth:
    username: default
    existingSecret: sourcebot
    existingSecretPasswordKey: redis-password
```

### Configuring a ingress

Enable ingress to expose Sourcebot:

```yaml
sourcebot:
  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: sourcebot.example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - hosts:
          - sourcebot.example.com
        secretName: sourcebot-tls
```

### Using an existing PVC

```yaml
sourcebot:
  persistence:
    existingClaim: my-existing-pvc
```

## Uninstalling

To uninstall/delete the `sourcebot` deployment:

```bash
helm uninstall sourcebot
```

This removes all Kubernetes components associated with the chart but **preserves PersistentVolumeClaims (PVCs) by default**. This includes:
- `sourcebot-data` - Sourcebot repository data and search indexes
- `data-sourcebot-postgresql-0` - PostgreSQL data (if deployed)
- `valkey-data-sourcebot-redis-*` - Redis data (if deployed)

To also remove all PVCs (⚠️ **this will delete all your data**):

```bash
kubectl delete pvc -l app.kubernetes.io/instance=sourcebot
```