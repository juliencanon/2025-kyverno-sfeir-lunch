
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Installation de Kyverno
![h-800 center](./assets/techready/demo-time.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Big Picture Kubernetes
![h500](./assets/techready/k8s_archi1.png)
Notes:
Kubernetes est un orchestrateur de container piloté via APIs <BR>
Les requêtes sont émises par :
- kubectl (outil CLI officiel)
- curl
- un outil tiers (k9s, headlamp, argoCD, ...)
- Validation des requêtes ( sur create, update, delete, patch...)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### "C'est là que les bactéries attaquent !"
![h500](./assets/techready/admission_schema.jpg)

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Kyverno : policy as code
![h-700](./assets/techready/police-kyverno.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
![h-800](./assets/techready/demo-time-girl.png)
Première policy

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Collection sur étagère
![h-800](./assets/techready/kyverno-website.png)
[https://kyverno.io/policies/?policytypes=validate](https://kyverno.io/policies/)

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Profitez du joli terrain de jeu
![h-800](./assets/techready/kyverno-website.png)
[https://playground.kyverno.io/#/](https://playground.kyverno.io/#/)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Rendre visible. Auditez !
![h-800](./assets/techready/popeye.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Kyverno ne se limite pas à un Admission Controller
![h500](./assets/techready/toolbox-trans.png)

Notes:
- Se voit comme une boîte à outil gérant tous les use-cases de la conformité
- S'installe dans le cluster, mais fournit également une version en ligne de commande (CLI)
- Kyverno 1.11 (16 Novembre 2023) implémente le langage CEL dans ses policies
- La bibliothèque de policies se ré-écrit progressivement en CEL




##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Mutation des requêtes (rectification du contenu, ajout, offuscation, cryptage...)
![h-600](./assets/techready/mutating-demo.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Generation de nouvelles resources
![h-600](./assets/techready/generating-demo.png)
Notes:
- Remplacement d'un operator simple



##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Respectons notre supply chain
![h-600](./assets/techready/origine-image.png)




##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Supply: Vérification des signatures d'images avec Notary
```yaml [2,12-13,16-17,26]
apiVersion: policies.kyverno.io/v1alpha1
kind: ImageValidatingPolicy
metadata:
  name: check-images
spec:
  matchConstraints:
    resourceRules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
  variables:
    - name: cm
      expression: >-
        resource.Get("v1", "configmaps", object.metadata.namespace, "keys")
  matchImageReferences:
    - glob: ghcr.io/*                         
  attestors:
        - name: notary
          notary:
            certs:
              value: |
                -----BEGIN CERTIFICATE-----
                MIIBjTCCATOgAwIBAgIUdMiN3gC...
                -----END CERTIFICATE-----
              expression: variables.cm.data.cert
```


##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Supply: vérification des attestations de conformité SBOM

```yaml [2,4,12-15,22-23,26]
apiVersion: policies.kyverno.io/v1alpha1
kind: ImageValidatingPolicy
metadata:
  name: check-images
spec:
  matchConstraints:
    resourceRules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
  matchImageReferences:
    - glob: ghcr.io/*
      attestors:
        - name: notary
          notary:
            certs:
              value: |-
                  -----BEGIN CERTIFICATE-----
                  ...
                  -----END CERTIFICATE-----
      attestations:
        - name: sbom
          referrer:
            type: sbom/cyclone-dx
  validations:
    - expression: >-
        images.containers.map(image, verifyImageSignatures(image, [attestors.notary])).all(e, e > 0)
      message: failed to verify image with notary cert
    - expression: >-
        images.containers.map(image, verifyAttestationSignatures(image, 
           attestations.sbom, [attestors.notary])).all(e, e > 0)
      message: failed to verify attestation with notary cert
    - expression: >-
        images.containers.map(image, extractPayload(image, attestations.sbom).bomFormat == 'CycloneDX').all(e, e)
      message: sbom is not a cyclone dx sbom
```




##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Clean : 2 façons de faire du nettoyage
![h-800](./assets/techready/clean-policy.png)



##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Cleanup Policy sur expression cron
```yaml [2,4,11-13,19]
apiVersion: kyverno.io/v2
kind: ClusterCleanupPolicy
metadata:
  name: cleandeploy
spec:
  match:
    any:
      - resources:
          kinds:
            - Deployment
          selector:
            matchLabels:
              canremove: "true"
  conditions:
    any:
      - key: "{{ target.spec.replicas }}"
        operator: LessThan
        value: 2
  schedule: "*/5 * * * *"
  # use Foreground deletion propagation policy
  deletionPropagationPolicy: Foreground
```

##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Cleanup Policy et PropagationPolicy
```yaml [20-21]
apiVersion: kyverno.io/v2
kind: ClusterCleanupPolicy
metadata:
  name: cleandeploy
spec:
  match:
    any:
      - resources:
          kinds:
            - Deployment
          selector:
            matchLabels:
              canremove: "true"
  conditions:
    any:
      - key: "{{ target.spec.replicas }}"
        operator: LessThan
        value: 2
  schedule: "*/5 * * * *"
  # use Foreground deletion propagation policy
  deletionPropagationPolicy: Foreground
```


##==##
<!-- .slide: class="with-code-dark max-height" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Cleanup Policy sur présence de ttl (label)
```yaml [2,5-6]
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-server
  labels:
    cleanup.kyverno.io/ttl: 2m
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-server
  template:
    metadata:
      labels:
        app: nginx-server
    spec:
      containers:
      - name: nginx-server
        image: nginx:1.27.5
```


##==##
<!-- .slide: data-background="./assets/lunch/bkgnd-lunch.png"-->
### Compatibilité entre Kyverno et VAP/MAP 

Kubernetes propose depuis la 1.26 des resources natives :
 ->  ValidatingAdmissionPolicy et MutatingAdmissionPolicy

- Intégrée en natif dans Kubernetes (facilité et résilence)
- Utilisent le langage CEL (simplicité et performance)


- Kyverno sait les générer à la volée
- Kyverno sait les tester

[https://kyverno.io/blog/2024/02/26/generating-kubernetes-validatingadmissionpolicies-from-kyverno-policies/](https://kyverno.io/blog/2024/02/26/generating-kubernetes-validatingadmissionpolicies-from-kyverno-policies/)



##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
![h-800](./assets/techready/demo-time-boy.png)
Kyverno test

