# Minimal Sourcebot Installation

This example demonstrates the simplest way to deploy Sourcebot to a Kubernetes cluster using Helm.

## Quick Start

### 1. Add the Helm Repository

```bash
helm repo add sourcebot https://sourcebot-dev.github.io/sourcebot-helm-chart
helm repo update
```

### 2. Generate Secrets

Edit `secrets.yaml` and replace the placeholder values:

```bash
# Generate AUTH_SECRET
openssl rand -base64 33

# Generate SOURCEBOT_ENCRYPTION_KEY
openssl rand -base64 24
```

Apply the secrets:

```bash
kubectl apply -f secrets.yaml
```

### 3. Configure Your Repositories

Edit `values.yaml` and update the repositories you want to index. See the [configuration docs](https://docs.sourcebot.dev/docs/configuration/config-file#config-file-schema) for more information.

### 4. Deploy

```bash
helm install sourcebot sourcebot/sourcebot -f values.yaml
```

### 5. Access Sourcebot

```bash
kubectl port-forward svc/sourcebot 3000:3000
```

Open http://localhost:3000

## Uninstalling

```bash
helm uninstall sourcebot
kubectl delete -f secrets.yaml

# Optionally, remove all PVCs (this will delete all data)
kubectl delete pvc -l app.kubernetes.io/instance=sourcebot
```

For more information, see the [main Helm chart documentation](../../README.md).
