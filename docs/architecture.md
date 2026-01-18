# Architecture

## Logical Diagram

```text
                 +----------------------+
                 |     Browser/User     |
                 +----------+-----------+
                            |
                            | (Port-forward or Ingress)
                            v
                    +-------+--------+
                    |    Frontend    |
                    |  svc: frontend |
                    |     :80        |
                    +---+--------+---+
                        |        |
                        |        |
                        v        v
              +---------+--+  +--+----------+
              | api-users  |  | api-orders  |
              | svc :8080  |  | svc :8080   |
              +-----+------+  +------+------+
                    |                |
                    |                |
                    v                v
              +-----+------+   +-----+------+
              |  Postgres  |   |   Redis    |
              | svc :5432  |   | svc :6379  |
              +------------+   +------------+



## Technologies & Tools

              | Category | Tools |
              |--------|------|
              | Container Orchestration | Kubernetes |
              | Local Cluster | kind |
              | GitOps | Argo CD |
              | CI Validation | GitHub Actions |
              | YAML Linting | yamllint |
              | Schema Validation | kubeconform |
              | Database | PostgreSQL |
              | Cache | Redis |
              | Build Tooling | Make |








