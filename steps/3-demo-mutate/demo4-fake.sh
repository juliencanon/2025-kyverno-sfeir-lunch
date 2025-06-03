
➜ 4-demo-mutate yq . < mut-ns-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-labels-namespace
spec:
  rules:
    - name: add-labels
      match:
        resources:
          kinds:
            - Namespace
      mutate:
        patchStrategicMerge:
          metadata:
            labels:
              +(mon-namespace): "{{request.object.metadata.name}}"
              +(installe-par): "kyverno"
➜ 4-demo-mutate kubectl create -f mut-ns-policy.yaml
clusterpolicy.kyverno.io/add-labels-namespace created
➜ 4-demo-mutate yq . < mut-deploy-inject-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-prometheus-exporter
spec:
  rules:
    - name: add-prometheus-exporter
      match:
        resources:
          kinds:
            - Deployment
      mutate:
        patchStrategicMerge:
          spec:
            template:
              spec:
                containers:
                  - name: prometheus-exporter
                    image: prom/node-exporter:v1.9.1
                    ports:
                      - containerPort: 9100
                    securityContext:
                      privileged: true
                    volumeMounts:
                      - name: proc
                        mountPath: /host/proc
                        readOnly: true
                volumes:
                  - name: proc
                    hostPath:
                      path: /proc
➜ 4-demo-mutate kubectl create -f mut-deploy-inject-p
olicy.yaml
clusterpolicy.kyverno.io/add-prometheus-exporter created
➜ 4-demo-mutate yq . < mut-pod-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-default-resources
spec:
  rules:
    - name: add-default-resources
      match:
        resources:
          kinds:
            - Pod
      exclude:
        resources:
          namespaces:
            - kube-system
      mutate:
        patchStrategicMerge:                                                                         spec:
            containers:
              - (name): "*"
                resources:
                  limits:
                    +(memory): "512Mi"
                    +(cpu): "500m"
                  requests:
                    +(memory): "128Mi"
                    +(cpu): "100m"
➜ 4-demo-mutate kubectl create -f mut-pod-policy.yaml
clusterpolicy.kyverno.io/add-default-resources created
➜ 4-demo-mutate kubectl get clusterpolicy
NAME                      ADMISSION   BACKGROUND   READY   AGE     MESSAGE
add-default-resources     true        true         True    3s      Ready
add-labels-namespace      true        true         True    28s     Ready
add-namespace-quota       true        true         True    6m6s    Ready
add-networkpolicy         true        true         True    6m32s   Ready
add-prometheus-exporter   true        true         True    13s     Ready
disallow-latest-tag       true        true         True    19m     Ready
➜ 4-demo-mutate yq . < mut-demo-ns.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mut-demo
➜ 4-demo-mutate kubectl create -f mut-demo-ns.yaml
namespace/mut-demo created
➜ 4-demo-mutate kubectl get namespace
NAME              STATUS   AGE
appli             Active   20m
default           Active   78m
gen-demo          Active   6m11s
kube-node-lease   Active   78m
kube-public       Active   78m
kube-system       Active   78m
kyverno           Active   68m
mut-demo          Active   6s
➜ 4-demo-mutate kubectl get namespace mut-demo -o yaml | yq .
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2025-06-02T15:36:47Z"
  labels:
    installe-par: kyverno
    kubernetes.io/metadata.name: mut-demo
    mon-namespace: mut-demo
  name: mut-demo
  resourceVersion: "14427"
  uid: ca38c332-055d-437a-bbb4-5715da684e4e
spec:
  finalizers:
    - kubernetes
status:
  phase: Active
➜ 4-demo-mutate yq . < nginx-deployment-version.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: mut-demo
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.27.5
          ports:
            - containerPort: 80
➜ 4-demo-mutate kubectl create -f nginx-deployment-version.yaml
deployment.apps/nginx-deploy created
➜ 4-demo-mutate kubectl get deploy -n mut-demo
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   1/2     2            1           6s
➜ 4-demo-mutate kubectl get deploy -n mut-demo -o yaml | yq .                              apiVersion: v1
items:
  - apiVersion: apps/v1
    kind: Deployment
    metadata:
      annotations:
        deployment.kubernetes.io/revision: "1"
      creationTimestamp: "2025-06-02T15:37:31Z"
      generation: 1
      labels:
        app: nginx
      name: nginx-deploy
      namespace: mut-demo
      resourceVersion: "14661"
      uid: 0e9bed2d-9eb1-4ada-a0da-27ea0dd3ebbc
    spec:
      progressDeadlineSeconds: 600
      replicas: 2
      revisionHistoryLimit: 10
      selector:
        matchLabels:
          app: nginx
      strategy:
        rollingUpdate:
          maxSurge: 25%
          maxUnavailable: 25%
        type: RollingUpdate
      template:
        metadata:
          creationTimestamp: null
          labels:
            app: nginx
        spec:
          containers:
            - image: prom/node-exporter:v1.9.1
              imagePullPolicy: IfNotPresent
              name: prometheus-exporter
              ports:
                - containerPort: 9100
                  protocol: TCP
              resources:
                limits:
                  cpu: 500m
                  memory: 512Mi
                requests:
                  cpu: 100m
                  memory: 128Mi
              securityContext:
                privileged: true
              terminationMessagePath: /dev/termination-log
              terminationMessagePolicy: File
              volumeMounts:
                - mountPath: /host/proc
                  name: proc
                  readOnly: true
            - image: nginx:1.27.5
              imagePullPolicy: IfNotPresent
              name: nginx-container
              ports:
                - containerPort: 80
                  protocol: TCP
              resources:
                limits:
                  cpu: 500m
                  memory: 512Mi
                requests:
                  cpu: 100m
                  memory: 128Mi
              terminationMessagePath: /dev/termination-log
              terminationMessagePolicy: File
          dnsPolicy: ClusterFirst
          restartPolicy: Always
          schedulerName: default-scheduler
          securityContext: {}
          terminationGracePeriodSeconds: 30
          volumes:
            - hostPath:
                path: /proc
                type: ""
              name: proc
    status:
      availableReplicas: 2
      conditions:
        - lastTransitionTime: "2025-06-02T15:37:41Z"
          lastUpdateTime: "2025-06-02T15:37:41Z"
          message: Deployment has minimum availability.
          reason: MinimumReplicasAvailable
          status: "True"
          type: Available
        - lastTransitionTime: "2025-06-02T15:37:31Z"
          lastUpdateTime: "2025-06-02T15:37:41Z"
          message: ReplicaSet "nginx-deploy-6949bfff57" has successfully progressed.
          reason: NewReplicaSetAvailable
          status: "True"
          type: Progressing
      observedGeneration: 1
      readyReplicas: 2
      replicas: 2
      updatedReplicas: 2
kind: List
metadata:
  resourceVersion: ""

