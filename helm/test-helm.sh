#!/bin/bash
set -e

echo "Testing Helm chart for syntax errors..."

# Lint the chart
helm lint helm/

echo ""
echo "Validating Helm templates..."

# Generate manifests (dry-run)
helm template code-agent helm/ \
  --namespace ai-assistant \
  --values helm/values.yaml \
  > /tmp/helm-manifests.yaml

echo "Generated manifests saved to: /tmp/helm-manifests.yaml"

echo ""
echo "Checking manifest validity..."

# Validate with kubectl
kubectl apply -f /tmp/helm-manifests.yaml --dry-run=client -o yaml > /dev/null

echo ""
echo "✅ All Helm validation checks passed!"
echo ""
echo "To deploy locally:"
echo "  helm install code-agent helm/ -n ai-assistant --create-namespace"
echo ""
echo "To upgrade:"
echo "  helm upgrade code-agent helm/ -n ai-assistant"
echo ""
echo "To uninstall:"
echo "  helm uninstall code-agent -n ai-assistant"
