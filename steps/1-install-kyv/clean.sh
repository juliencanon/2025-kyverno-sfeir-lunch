#!/bin/bash

kubectl delete clusterpolicy --all
helm uninstall kyverno -n kyverno
kubectl delete ns kyverno
helm repo remove kyverno

