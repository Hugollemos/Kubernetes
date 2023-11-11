# comando para ver os nodes
kubectl get nodes

# comando para ver os clusters configurados
```
kubectl config get-clusters
```
# comando para especificar um cluster para monitorar 
```
kubectl config use-context nome_do_clusters
```
# comando para ver os pods
kubectl get pod ou kubectl get po

# redirecionando as portas para expor
kubectl port-forward pod/nome_do_pod 80:80

# deletando um pod
kubectl delete pod goserver

## Deployment
Deployment > ReplicaSet > Pod

## Rollout e Revisoes
>historicos da versoes dos deployment
kubectl rollout history deployment nome_do_deploy

> volta para ultima vesao que estava rodando
kubectl rollout undo deployment nome_do_deploy

>volta para a versao especificada na qual se deseja voltar.
kubectl rollout undo deployment nome_do_deploy --to-revision

# services
services é a porta de entrada para a aplicação que por default não da para acessar.
obs: O service também atua como load balancer 

# utilizando proxy para acessar API do kubernetes
kubectl proxy --port=8080

# Variáveis de ambiente
```
 spec:
      containers:
        - name: goserver
          image: "hugollemos/teste:latest"
          env:
            - name: NAME
              value: "hugo"
            - name: AGE
              value: "24"
```
# ConfigMap

# Probes/ Health

----
kubectl get namespaces

kubectl get pod -n kube-system

kubectl get pods -A
lista todos os pods de todos os namespaces 

kubectl get pods -A -o wide
disponibiliza maiores informacoes sobre o recurso, inclusive em qual nó o pods está 
kubectl run nginx --image nginx

kubectl run giropops --image=nginx --port=80

kubectl get pods --all-namespaces

```
apiVersion: v1 # versão da API do Kubernetes
kind: Pod # tipo do objeto que estamos criando
metadata: # metadados do Pod 
  name: giropops # nome do Pod que estamos criando
labels: # labels do Pod
  run: giropops # label run com o valor giropops
spec: # especificação do Pod
  containers: # containers que estão dentro do Pod
  - name: giropops # nome do container
    image: nginx # imagem do container
    ports: # portas que estão sendo expostas pelo container
    - containerPort: 80 # porta 80 exposta pelo container
```

```
apiVersion: v1 # versão da API do Kubernetes
kind: Pod # tipo do objeto que estamos criando
metadata: # metadados do Pod 
  name: giropops # nome do Pod que estamos criando
labels: # labels do Pod
  run: giropops # label run com o valor giropops
spec: # especificação do Pod
  containers: # containers que estão dentro do Pod
  - name: girus # nome do container
    image: nginx # imagem do container
    ports: # portas que estão sendo expostas pelo container
    - containerPort: 80 # porta 80 exposta pelo container
  - name: strigus # nome do container
    image: alpine # imagem do container
    args:
    - sleep
    - "1800"
```

```
apiVersion: v1 # versão da API do Kubernetes
kind: Pod # tipo do objeto que estamos criando
metadata: # metadados do Pod
  name: giropops # nome do Pod que estamos criando
labels: # labels do Pod
  run: giropops # label run com o valor giropops
spec: # especificação do Pod 
  containers: # containers que estão dentro do Pod 
  - name: girus # nome do container 
    image: nginx # imagem do container
    ports: # portas que estão sendo expostas pelo container
    - containerPort: 80 # porta 80 exposta pelo container
    resources: # recursos que estão sendo utilizados pelo container
      limits: # limites máximo de recursos que o container pode utilizar
        memory: "128Mi" # limite de memória que está sendo utilizado pelo container, no caso 128 megabytes no máximo 
        cpu: "0.5" # limite máxima de CPU que o container pode utilizar, no caso 50% de uma CPU no máximo
      requests: # recursos garantidos ao container
        memory: "64Mi" # memória garantida ao container, no caso 64 megabytes
        cpu: "0.3" # CPU garantida ao container, no caso 30% de uma CPU
```


O k8s organiza tudo dentro de namespaces. Por meio deles, podem ser realizadas limitações de segurança e de recursos dentro do cluster, tais como pods, replication controllers e diversos outros. Para visualizar os namespaces disponíveis no cluster, digite:

kubectl get namespaces

kubectl run meu-nginx --image nginx --dry-run=client -o yaml > pod-template.yaml
podemos simular a criação de um resource e ainda ter um manifesto criado automaticamente.


kubectl get all

kubectl get pod,service

kubectl get pod,svc
ver  os recursos recem criados
```
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 2
```
maxSurge: define a quantidade máxima de Pods que podem ser criados a mais durante a atualização, ou seja, durante o processo de atualização, nós podemos ter 1 Pod a mais do que o número de Pods definidos no Deployment. Isso é útil pois agiliza o processo de atualização, pois o Kubernetes não precisa esperar que um Pod seja atualizado para criar um novo Pod.

maxUnavailable: define a quantidade máxima de Pods que podem ficar indisponíveis durante a atualização, ou seja, durante o processo de atualização, nós podemos ter 1 Pod indisponível por vez. Isso é útil pois garante que o serviço não fique indisponível durante a atualização.

type: define o tipo de estratégia de atualização que será utilizada, no nosso caso, nós estamos utilizando a estratégia RollingUpdate.

