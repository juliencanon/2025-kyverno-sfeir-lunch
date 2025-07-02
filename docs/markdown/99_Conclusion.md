
<!-- .slide: data-background="./assets/lunch/bkgnd-lunch.png"-->
### Méthodologie :
- Commencer tranquillement
- Une première policy en Audit
- Suivi du pourcentage de conformité
- Passer jusqu'à 100%
- Passer en Enforce
- Continuer d'ajouter de nouvelles Policies
<!-- .element: class="list-fragment" -->


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Processus d'amélioration continue
![h500](./assets/techready/roue-demming.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Pod Security Standard
- interdiction des capabilities
- interdiction des escalations de privilege
- interdiction de tourner sous l'indentité root
- séparer les namespaces de la machine hôte (PID, IPC, Network, HostAlias,...)

[https://kubernetes.io/docs/concepts/security/pod-security-standards/](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### helm chart kyverno-policies
![h-800](./assets/techready/demo-time-3.png)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Autres exemples de référentiels à implémenter selon les contraintes

- NIST SP 800-190
- CIS Kubernetes Benchmark
- ISO 27001
- SOC 2
- PCI DSS
- HDS
- MITTR&TTack
- SecNumCloud


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Cadre méthodologique
#### Conserver toutes les pratiques en amont (non regression, fail fast, tests sécu).
- Pratiques devops, pipelines CI/CD
- Fail fast / Shift left
- Amélioration continue Roue de Deming
- Tests unitaires, non regression
- Tests de Qualité du code
- Tests Sécurité statique et dynamique
<!-- .element: class="list-fragment" -->



##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
### Take away
- Un précieux allié pour mettre en place la conformité et son suivi dans le temps
- Mettre en place les bons mécanisme by-design en amont
- Mettre en place en mode audit -> Animer de façon hebdo/mensuelle sur le reporting
- Mettre en place en Enforce -> Certitude + policyException en cas de besoin hors catégorie validé.
- C'est le gardien du temple en aval (police, audit, kpi de suivi de conformité)
<!-- .element: class="list-fragment" -->

##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Kyverno, c'est de la dynamite ! 🧨
![h500](./assets/techready/dynamite.webp)


##==##
<!-- .slide: class="flex-row center" data-background="./assets/lunch/bkgnd-lunch.png"-->
#### Questions & Feedback
Avez-vous des questions ?
Notes:
https://www.qrcode-monkey.com/fr/


