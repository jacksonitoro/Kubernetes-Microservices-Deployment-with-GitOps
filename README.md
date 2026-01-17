# Kubernetes Microservices Deployment with GitOps

A Kubernetes-deployed microservices stack (frontend + two backend APIs) backed by PostgreSQL and Redis, continuously reconciled to the desired state using Argo CD (GitOps).

## Architecture

**Namespace:** `mymicro`  
**Components:**
- `frontend` (Service: `frontend:80`)
- `api-users` (Service: `api-users:8080`)
- `api-orders` (Service: `api-orders:8080`)
- `postgres` (Service: `postgres:5432`)
- `redis` (Service: `redis:6379`)
- Ingress routes (optional): `micro.local/`, `micro.local/users`, `micro.local/orders`

See: [docs/architecture.md](docs/architecture.md)

## Repository Layout

```text
k8s/
  00-namespace/
  01-config/
  02-secrets/        # do NOT commit plaintext secrets
  03-db-cache/
  04-backends/
  05-frontend/
  06-ingress/
argocd/
  mymicro-app.yaml   # Argo CD Application (GitOps)
.github/workflows/
  ci.yml             # yamllint + kubeconform

