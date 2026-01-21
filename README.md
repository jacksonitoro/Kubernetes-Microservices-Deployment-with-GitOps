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

## Repository Structure

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

## Prerequisites


```
**Install the following tools:**
- Docker
- kubectl
- kind 
- Git
- make

## Step-by-Step Setup

## 1. Create a Kubernetes Cluster

```text


 kind create cluster --name myfirst-demo
 kubectl config use-context kind-myfirst-demo

## 2. Install Argo CD

```text

 kubectl create namespace argocd
 kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


### Wait until Argo CD is ready:

```text
 kubectl get pods -n argocd -w

## 3. Create the Database Secret (Required)
### Secrets are intentionally not stored in Git.

```text
 kubectl -n mymicro create secret generic db-secret \
  --from-literal=POSTGRES_USER=appuser \
  --from-literal=POSTGRES_PASSWORD=changeme \
  --from-literal=POSTGRES_DB=appdb

## 4. Deploy the Application (GitOps)

### Apply the Argo CD Application:

```text
 kubectl apply -f argocd/mymicro-app.yaml

## Check status:

```text
 kubectl -n argocd get applications

## Argco CD will automatically:

````
- Create resources
- Keep them in sync
- Self-heal drift

## Accessing the Application
## Option 1: Port Forward (Fastest)


```text
 make port-forward-frontend

### Open in browser:

```text
 http://localhost:8085   # any port of your choice

## APIs (Optional)

```text
 make port-forward-users
 make port-forward-orders

## GitOps Workflow
### 1. Make changes to Kubernetes manifests

### 2. Commit and push to main

### 3. Argo CD detects changes

### 4. Cluster state is reconciled automatically

## Drift Example

```text

 kubectl -n mymicro scale deploy/frontend --replicas=1

## Argo CD will automatically restore the replica count from Git.

## CI Validation
### On every push or pull request:

```text
    - yamllint checks YAML formatting
    - kubeconform validates kubernetes schemas

### This prevents invalid manifests from reaching the cluster.


## Secrets Management

### Current approach:
```
    - Secrets created manually (safe for local/dev)
### Recommended future approaches:
    - Sealed Secrets
    - External Secrets Operator (Vault/Cloud Secret Managers)

## Common Commands

```text
make status                 # Show cluster status
make port-forward-frontend  # Access frontend
make deploy-argocd          # Reapply Argo CD app
make logs-frontend          # View frontend logs








