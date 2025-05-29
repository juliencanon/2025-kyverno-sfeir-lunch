#!/bin/bash

echo "## Démarrage de colima ##"
echo "-------------------------"
colima start
echo "## Démarrage minikube  ##"
echo "-------------------------"
minikube start --nodes 2 -p enterprise
sleep 20
echo "## Vérification nodes  ##"
echo "-------------------------"
kubectl get nodes
echo "## Vérification ns     ##"
echo "-------------------------"
kubectl get namespaces

