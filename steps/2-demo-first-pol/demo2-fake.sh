#!/bin/bash

➜ 2-demo-first-pol kubectl get namespace
NAME              STATUS   AGE
default           Active   49m
kube-node-lease   Active   49m
kube-public       Active   49m
kube-system       Active   49m
kyverno           Active   38m
➜ 2-demo-first-pol kubectl create -f appli-ns.yaml
namespace/appli created
➜ 2-demo-first-pol kubectl get namespace
NAME              STATUS   AGE
appli             Active   5s
default           Active   49m
kube-node-lease   Active   49m
kube-public       Active   49m
kube-system       Active   49m
kyverno           Active   38m
➜ 2-demo-first-pol yq . < appli-pod-latest.yaml
apiVersion: v1
kind: Pod
metadata:
  name: appli-latest
  namespace: appli
spec:
  containers:
    - name: appli-container
      image: nginx:latest
➜ 2-demo-first-pol kubectl create -f appli-pod-latest.yaml
pod/appli-latest created
➜ 2-demo-first-pol kubectl get pods -n appli
NAME           READY   STATUS              RESTARTS   AGE                                  appli-latest   0/1     ContainerCreating   0          5s
➜ 2-demo-first-pol kubectl get pods -n appli
NAME           READY   STATUS    RESTARTS   AGE                                            appli-latest   1/1     Running   0          17s                                            ./demo2.sh: line 18: clean: command not found
Nettoyage

➜ 2-demo-first-pol kubectl delete -f appli-pod-latest.yaml
pod "appli-latest" deleted
➜ 2-demo-first-pol kubectl get pods -n appli
No resources found in appli namespace.
./demo2.sh: line 24: clean: command not found
Ajoutons une policy

➜ 2-demo-first-pol yq . < kyv-pol-disable-latest.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-latest-tag
  annotations:
    policies.kyverno.io/title: Disallow Latest Tag
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/minversion: 1.6.0
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/description: The ':latest' tag is not suitable.
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: require-image-tag
      match:
        any:
          - resources:
              kinds:
                - Pod
      validate:
        message: "An image tag is required."
        foreach:
          - list: "request.object.spec.containers"
            pattern:
              image: "*:*"
          - list: "request.object.spec.initContainers"
            pattern:
              image: "*:*"
          - list: "request.object.spec.ephemeralContainers"
            pattern:
              image: "*:*"
    - name: validate-image-tag
      match:
        any:
          - resources:
              kinds:
                - Pod
      validate:
        message: "Using a mutable image tag e.g. 'latest' is not allowed."
        foreach:
          - list: "request.object.spec.containers"
            pattern:
              image: "!*:latest"
          - list: "request.object.spec.initContainers"
            pattern:
              image: "!*:latest"
          - list: "request.object.spec.ephemeralContainers"
            pattern:
              image: "!*:latest"
➜ 2-demo-first-pol kubectl create -f kyv-pol-disable-latest.yaml
clusterpolicy.kyverno.io/disallow-latest-tag created
➜ 2-demo-first-pol kubectl get clusterpolicy                                               NAME                  ADMISSION   BACKGROUND   READY   AGE   MESSAGE
disallow-latest-tag   true        true         True    5s    Ready
➜ 2-demo-first-pol kubectl create -f appli-pod-latest.yaml
Error from server: error when creating "appli-pod-latest.yaml": admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/appli/appli-latest was blocked due to the following policies

disallow-latest-tag:
  validate-image-tag: 'validation failure: validation error: Using a mutable image
    tag e.g. ''latest'' is not allowed. rule validate-image-tag failed at path /image/'
➜ 2-demo-first-pol kubectl get pods -n appli
No resources found in appli namespace.
➜ 2-demo-first-pol yq . < appli-pod-version.yaml
apiVersion: v1
kind: Pod
metadata:
  name: appli-version
  namespace: appli
spec:
  containers:
    - name: appli-container
      image: nginx:1.27.5
➜ 2-demo-first-pol kubectl create -f appli-pod-version.yaml
pod/appli-version created
➜ 2-demo-first-pol kubectl get pods -n appli
NAME            READY   STATUS    RESTARTS   AGE
appli-version   1/1     Running   0          5s
➜ 2-demo-first-pol kubectl get pods -n appli
NAME            READY   STATUS    RESTARTS   AGE
appli-version   1/1     Running   0          14s
💡Bonus 😍
➜ 2-demo-first-pol yq . < appli-deployment-version.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appli-deployment
  labels:
    app: appli
spec:
  replicas: 2
  selector:
    matchLabels:
      app: appli
  template:
    metadata:
      labels:
        app: appli
    spec:
      containers:
        - name: appli-container
          image: nginx:latest
          ports:
            - containerPort: 80
➜ 2-demo-first-pol kubectl create -f appli-deployment-version.yaml
Error from server: error when creating "appli-deployment-version.yaml": admission webhook "validate.kyverno.svc-fail" denied the request:

resource Deployment/default/appli-deployment was blocked due to the following policies

disallow-latest-tag:
  autogen-validate-image-tag: 'validation failure: validation error: Using a mutable
    image tag e.g. ''latest'' is not allowed. rule autogen-validate-image-tag failed
    at path /image/'
➜ 2-demo-first-pol kubectl get clusterpolicy disallow-latest-tag -o yaml | yq .
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  annotations:
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/description: The ':latest' tag is not suitable.
    policies.kyverno.io/minversion: 1.6.0
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/title: Disallow Latest Tag
  creationTimestamp: "2025-06-02T15:09:14Z"
  generation: 1
  name: disallow-latest-tag
  resourceVersion: "8593"
  uid: e4b67b36-0aef-428c-b350-f338534fd067
spec:
  admission: true
  background: true
  emitWarning: false
  rules:
    - match:
        any:
          - resources:
              kinds:
                - Pod
      name: require-image-tag
      skipBackgroundRequests: true
      validate:
        allowExistingViolations: true
        foreach:
          - list: request.object.spec.containers
            pattern:
              image: '*:*'
          - list: request.object.spec.initContainers
            pattern:
              image: '*:*'
          - list: request.object.spec.ephemeralContainers
            pattern:
              image: '*:*'
        message: An image tag is required.
    - match:
        any:
          - resources:
              kinds:
                - Pod
      name: validate-image-tag
      skipBackgroundRequests: true
      validate:
        allowExistingViolations: true
        foreach:
          - list: request.object.spec.containers
            pattern:
              image: '!*:latest'
          - list: request.object.spec.initContainers
            pattern:
              image: '!*:latest'
          - list: request.object.spec.ephemeralContainers
            pattern:
              image: '!*:latest'
        message: Using a mutable image tag e.g. 'latest' is not allowed.
  validationFailureAction: Enforce
status:
  autogen:
    rules:
      - match:
          any:
            - resources:
                kinds:
                  - DaemonSet
                  - Deployment
                  - Job
                  - ReplicaSet
                  - ReplicationController
                  - StatefulSet
          resources: {}
        name: autogen-require-image-tag
        skipBackgroundRequests: true
        validate:
          allowExistingViolations: true
          foreach:
            - list: request.object.spec.template.spec.containers
              pattern:
                image: '*:*'
            - list: request.object.spec.template.spec.initContainers
              pattern:
                image: '*:*'
            - list: request.object.spec.template.spec.ephemeralContainers
              pattern:
                image: '*:*'
          message: An image tag is required.
      - match:
          any:
            - resources:
                kinds:
                  - CronJob
          resources: {}
        name: autogen-cronjob-require-image-tag
        skipBackgroundRequests: true
        validate:
          allowExistingViolations: true
          foreach:
            - list: request.object.spec.jobTemplate.spec.template.spec.containers
              pattern:
                image: '*:*'
            - list: request.object.spec.jobTemplate.spec.template.spec.initContainers
              pattern:
                image: '*:*'
            - list: request.object.spec.jobTemplate.spec.template.spec.ephemeralContainers
              pattern:
                image: '*:*'
          message: An image tag is required.
      - match:
          any:
            - resources:
                kinds:
                  - DaemonSet
                  - Deployment
                  - Job
                  - ReplicaSet
                  - ReplicationController
                  - StatefulSet
          resources: {}
        name: autogen-validate-image-tag
        skipBackgroundRequests: true
        validate:
          allowExistingViolations: true
          foreach:
            - list: request.object.spec.template.spec.containers
              pattern:
                image: '!*:latest'
            - list: request.object.spec.template.spec.initContainers
              pattern:
                image: '!*:latest'
            - list: request.object.spec.template.spec.ephemeralContainers
              pattern:
                image: '!*:latest'
          message: Using a mutable image tag e.g. 'latest' is not allowed.
      - match:
          any:
            - resources:
                kinds:
                  - CronJob
          resources: {}
        name: autogen-cronjob-validate-image-tag
        skipBackgroundRequests: true
        validate:
          allowExistingViolations: true
          foreach:
            - list: request.object.spec.jobTemplate.spec.template.spec.containers
              pattern:
                image: '!*:latest'
            - list: request.object.spec.jobTemplate.spec.template.spec.initContainers
              pattern:
                image: '!*:latest'
            - list: request.object.spec.jobTemplate.spec.template.spec.ephemeralContainers
              pattern:
                image: '!*:latest'
          message: Using a mutable image tag e.g. 'latest' is not allowed.
  conditions:
    - lastTransitionTime: "2025-06-02T15:09:14Z"
      message: Ready
      reason: Succeeded
      status: "True"
      type: Ready
  rulecount:
    generate: 0
    mutate: 0
    validate: 2
    verifyimages: 0
  validatingadmissionpolicy:
    generated: false
    message: ""
