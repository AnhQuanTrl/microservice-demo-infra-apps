#!/bin/bash
if [ -z "${POLICY_TOKEN}" ]; then
	echo "Missing token"
	exit 1
fi
kubectl apply -f bootstrap/cluster-resources/management/namespace.yaml
cd apps/external-secrets/base || exit
helm repo add external-secrets https://charts.external-secrets.io
helm dependency build
helm template external-secrets . --values ../envs/management/values.yaml | kubectl apply -f -
cd ../../..
kubectl create secret generic vault-token --namespace argocd --from-literal=token=${POLICY_TOKEN}
kubectl kustomize bootstrap/argocd | kubectl apply -f -
