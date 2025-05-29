#!/bin/bash

echo "## Extinction des feux ##"
echo "-------------------------"
minikube stop -p enterprise
minikube delete -p enterprise
colima stop
helm repo remove kyverno
helm repo remove policy-reporter
echo "##    Vérifications    ##"
echo "-------------------------"
minikube profile list
colima status

