# Sourcebot Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v4.7.3](https://img.shields.io/badge/AppVersion-v4.7.3-informational?style=flat-square)

The open source Sourcegraph alternative. Sourcebot gives you a powerful interface to search through all your repos and branches across multiple code hosts.

**Homepage:** <https://sourcebot.dev/>

## TL;DR

```bash
# Create a secret with your credentials
kubectl create secret generic sourcebot \
  --from-literal=postgresql-password=your-secure-password \
  --from-literal=redis-password=your-secure-password

# Add the Helm repository
helm repo add sourcebot https://sourcebot-dev.github.io/sourcebot-helm-chart
helm repo update

# Install Sourcebot
helm install sourcebot sourcebot/sourcebot \
  --set postgresql.auth.existingSecret=sourcebot \
  --set redis.auth.existingSecret=sourcebot
```

## Introduction

This chart bootstraps a Sourcebot deployment on a Kubernetes cluster using the Helm package manager.

By default, this chart deploys:
- Sourcebot application
- PostgreSQL database (via Bitnami subchart)
- Redis/Valkey cache (via Bitnami subchart)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x
- PV provisioner support in the underlying infrastructure (for PostgreSQL and Sourcebot data persistence)

## Installing the Chart

### Quick Start

See the [minimal installation example](./examples/minimal-installation/) for a complete quick start guide.

### Step-by-Step Installation

1. **Create a Secret** with your database and Redis passwords:

```bash
kubectl create secret generic sourcebot \
  --from-literal=postgresql-password=your-secure-password \
  --from-literal=redis-password=your-secure-password
```

2. **Add the Helm Repository**:

```bash
helm repo add sourcebot https://sourcebot-dev.github.io/sourcebot-helm-chart
helm repo update
```

3. **Install the Chart**:

```bash
helm install sourcebot sourcebot/sourcebot \
  --set postgresql.auth.existingSecret=sourcebot \
  --set redis.auth.existingSecret=sourcebot
```

Or using a values file:

```bash
helm install sourcebot sourcebot/sourcebot -f values.yaml
```

## Configuration

### Database Configuration

By default, PostgreSQL is deployed as a subchart. The chart automatically configures the connection using component-based environment variables (`DATABASE_HOST`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, etc.), which are assembled into `DATABASE_URL` by the application's entrypoint script.

#### Using the Deployed PostgreSQL Subchart

```yaml
postgresql:
  deploy: true  # Default
  auth:
    username: sourcebot
    database: sourcebot
    existingSecret: sourcebot
    secretKeys:
      userPasswordKey: postgresql-password
      adminPasswordKey: postgresql-password
  primary:
    persistence:
      enabled: true
      size: 8Gi
```

#### Using an External PostgreSQL Instance

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
      userPasswordKey: postgresql-password
```

### Redis Configuration

Similar to PostgreSQL, Redis/Valkey can be deployed as a subchart or configured to use an external instance.

#### Using the Deployed Redis Subchart

```yaml
redis:
  deploy: true  # Default
  auth:
    username: default
    existingSecret: sourcebot
    existingSecretPasswordKey: redis-password
```

#### Using an External Redis Instance

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

### Sourcebot Configuration

Configure your code repositories and other settings:

```yaml
sourcebot:
  config:
    $schema: https://raw.githubusercontent.com/sourcebot-dev/sourcebot/main/schemas/v3/index.json
    connections:
      github-repos:
        type: github
        token:
          env: GITHUB_TOKEN
        repos:
          - owner/repo1
          - owner/repo2
    settings:
      reindexIntervalMs: 86400000  # 24 hours
```

### Persistence Configuration

By default, Sourcebot uses persistent storage to retain repository data and search indexes across pod restarts:

```yaml
sourcebot:
  persistence:
    enabled: true  # Default
    size: 10Gi
    storageClass: ""  # Uses cluster default
    accessModes:
      - ReadWriteOnce
```

To use an existing PersistentVolumeClaim:

```yaml
sourcebot:
  persistence:
    enabled: true
    existingClaim: my-existing-pvc
```

To disable persistence (not recommended for production):

```yaml
sourcebot:
  persistence:
    enabled: false
```

### Ingress Configuration

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

### Resource Limits

Set appropriate resource limits for production:

```yaml
sourcebot:
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

## Examples

Check out the [examples directory](./examples/) for complete configuration examples:

- [Minimal Installation](./examples/minimal-installation/) - Basic setup with subcharts
- More examples coming soon!

## Upgrading

### To a New Version

```bash
helm upgrade sourcebot sourcebot/sourcebot -f values.yaml
```

### Major Version Upgrades

Always check the [CHANGELOG](../../CHANGELOG.md) for breaking changes before upgrading between major versions.

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