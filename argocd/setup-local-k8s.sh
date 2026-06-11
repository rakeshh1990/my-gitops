#!/bin/bash
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Setting up Local Kubernetes with ArgoCD ===${NC}"

# Check if minikube is installed
if ! command -v minikube &> /dev/null; then
    echo -e "${RED}minikube is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${RED}helm is not installed. Please install it first.${NC}"
    exit 1
fi

# Start minikube
echo -e "${YELLOW}Starting minikube...${NC}"
minikube start --cpus=4 --memory=8192 --driver=docker

# Wait for minikube to be ready
echo -e "${YELLOW}Waiting for minikube to be ready...${NC}"
kubectl wait --for=condition=Ready node/minikube --timeout=300s || true

# Add Helm repositories
echo -e "${YELLOW}Adding Helm repositories...${NC}"
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update

# Create argocd namespace
echo -e "${YELLOW}Creating ArgoCD namespace...${NC}"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install ArgoCD
echo -e "${YELLOW}Installing ArgoCD...${NC}"
helm upgrade --install argocd argocd/argo-cd \
  --namespace argocd \
  --set server.insecure=true \
  --set server.service.type=NodePort \
  --wait

# Create ai-assistant namespace
echo -e "${YELLOW}Creating ai-assistant namespace...${NC}"
kubectl create namespace ai-assistant --dry-run=client -o yaml | kubectl apply -f -

# Display ArgoCD UI access information
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo -e "${YELLOW}Access ArgoCD UI:${NC}"
echo "1. Port-forward to ArgoCD server:"
echo "   kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo ""
echo "2. Open in browser: http://localhost:8080"
echo ""
echo -e "${YELLOW}Get ArgoCD initial password:${NC}"
echo "   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo ""
echo -e "${YELLOW}Apply ArgoCD Application:${NC}"
echo "   kubectl apply -f argocd/application.yaml"
echo ""
echo -e "${YELLOW}Check application status:${NC}"
echo "   kubectl get application -n argocd"
echo "   argocd app get code-agent"
