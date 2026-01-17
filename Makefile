SHELL := /bin/bash

NAMESPACE ?= mymicro
ARGO_NS ?= argocd
APP ?= mymicro

.PHONY: help status deploy deploy-k8s deploy-argocd port-forward-frontend port-forward-users port-forward-orders logs-frontend logs-users logs-orders

help:
	@echo "Targets:"
	@echo "  make status                - Show pods/services/ingress"
	@echo "  make deploy-k8s             - Apply Kubernetes manifests (manual)"
	@echo "  make deploy-argocd           - Apply Argo CD Application (GitOps)"
	@echo "  make port-forward-frontend  - Forward frontend to localhost:8085"
	@echo "  make port-forward-users     - Forward api-users to localhost:8081"
	@echo "  make port-forward-orders    - Forward api-orders to localhost:8082"
	@echo "  make logs-frontend          - Tail frontend logs"
	@echo "  make logs-users             - Tail api-users logs"
	@echo "  make logs-orders            - Tail api-orders logs"

status:
	kubectl get pods -n $(NAMESPACE)
	kubectl get svc -n $(NAMESPACE)
	kubectl get ingress -n $(NAMESPACE) || true
	@echo
	kubectl -n $(ARGO_NS) get app $(APP) -o wide || true

deploy-k8s:
	kubectl apply -f k8s/00-namespace/
	kubectl apply -f k8s/01-config/
	kubectl apply -f k8s/03-db-cache/
	kubectl apply -f k8s/04-backends/
	kubectl apply -f k8s/05-frontend/
	kubectl apply -f k8s/06-ingress/ || true

deploy-argocd:
	kubectl apply -f argocd/mymicro-app.yaml
	kubectl -n $(ARGO_NS) get app $(APP) -o wide

port-forward-frontend:
	kubectl -n $(NAMESPACE) port-forward svc/frontend 8085:80

port-forward-users:
	kubectl -n $(NAMESPACE) port-forward svc/api-users 8081:8080

port-forward-orders:
	kubectl -n $(NAMESPACE) port-forward svc/api-orders 8082:8080

logs-frontend:
	kubectl -n $(NAMESPACE) logs -l app=frontend -f --tail=200

logs-users:
	kubectl -n $(NAMESPACE) logs -l app=api-users -f --tail=200

logs-orders:
	kubectl -n $(NAMESPACE) logs -l app=api-orders -f --tail=200

