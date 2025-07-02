#!/bin/bash

echo "## Démarrage de colima ##"
echo "-------------------------"
colima start
echo "## Démarrage minikube  ##"
echo "-------------------------"
minikube start --nodes 2 -p policy-reporter
sleep 20
echo "## Vérification nodes  ##"
echo "-------------------------"
kubectl get nodes
echo "## Vérification ns     ##"
echo "-------------------------"
kubectl get namespaces

helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace

helm repo add policy-reporter https://kyverno.github.io/policy-reporter
helm repo update
helm install policy-reporter policy-reporter/policy-reporter --create-namespace -n policy-reporter --set metrics.enabled=true

kubectl get namespaces
kubectl get deployment -n policy-reporter

kubectl get svc -n policy-reporter
#kubectl port-forward service/policy-reporter 8082:8080 -n policy-reporter
# curl http://localhost:8082/metrics

helm install policy-reporter policy-reporter/policy-reporter --set plugin.kyverno.enabled=true --set ui.enabled=true -n policy-reporter --create-namespace
kubectl port-forward service/policy-reporter-ui 8082:8080 -n policy-reporter

#helm upgrade --install policy-reporter policy-reporter/policy-reporter --create-namespace -n policy-reporter --set ui.enabled=true

kubectl port-forward service/policy-reporter-ui 8081:8080 -n policy-reporter



exit


 kubectl get clusterpolicy
 kubectl delete clusterpolicy --all

 kubectl create -f namespaces.yaml
 kubectl create -f sgbd.yaml
 kubectl create -f backend.yaml
 kubectl create -f configmap.yaml
 kubectl create -f dev-app.yaml
 kubectl create -f frontend.yaml
 kubectl create -f pods.yaml
 kubectl create -f services.yaml


 kubectl port-forward service/policy-reporter-ui 8081:8080 -n policy-reporter
 kubectl create -f policies/
 kubectl get policyreports -A


helm upgrade policy-reporter policy-reporter/policy-reporter \
  --version 3.0.4 \
  --set plugin.kyverno.enabled=true \
  --set ui.enabled=true \
  -n policy-reporter



