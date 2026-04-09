# Contributing

## Local Development

### Prerequisites

- [Helm 3.x](https://helm.sh/docs/intro/install/)
- A local Kubernetes cluster (e.g., [minikube](https://minikube.sigs.k8s.io/docs/start/)). The default resource requests require at least 12GB of memory. For minikube, configure this before creating your cluster:
  ```bash
  minikube config set memory 12288  # 12GB
  ```

### Building Dependencies

Fetch the subchart dependencies (PostgreSQL, Valkey). You only need to re-run this when the dependencies in `Chart.yaml` are updated:

```bash
helm dependency build ./charts/sourcebot
```

### Deploying Locally

Apply the secrets and deploy the minimal installation example:

```bash
kubectl apply -f examples/minimal-installation/secrets.yaml
helm upgrade --install sourcebot ./charts/sourcebot \
  -f examples/minimal-installation/values.yaml \
  --set-json "sourcebot.config=$(cat examples/minimal-installation/config.json)"
```

Port forward to access Sourcebot at http://localhost:3000:

```bash
kubectl port-forward svc/sourcebot 3000:3000
```

### Validating Changes

Lint the chart:

```bash
helm lint ./charts/sourcebot -f ./charts/sourcebot/values.lint.yaml
```

Render templates locally without deploying:

```bash
helm template sourcebot ./charts/sourcebot -f ./charts/sourcebot/values.lint.yaml
```

Run the chart tests:

```bash
helm test sourcebot
```

### Updating Docs

The chart README is auto-generated from `values.yaml` comments using [helm-docs](https://github.com/norwoodj/helm-docs). After modifying `values.yaml`, regenerate the docs:

```bash
helm-docs --chart-search-root ./charts
```