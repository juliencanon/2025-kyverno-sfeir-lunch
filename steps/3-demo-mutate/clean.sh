#!/bin/bash

kubectl delete -f mut-ns-policy.yaml
kubectl delete -f mut-deploy-inject-policy.yaml
kubectl delete -f mut-pod-policy.yaml
kubectl delete -f nginx-deployment-version.yaml
kubectl delete -f mut-demo-ns.yaml

