#!/bin/bash

kubectl delete -f gen-netpol-policy.yaml
kubectl delete -f gen-quota-policy.yaml
kubectl delete -f gen-demo-ns.yaml

