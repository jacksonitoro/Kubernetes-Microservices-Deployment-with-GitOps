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

