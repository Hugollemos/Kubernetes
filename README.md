# Kubernetes

# comando para ver os nodes
kubectl get nodes

# comando para ver os clsuters configurados
```
kubectl config get-clusters
```
# comando para espesificar um cluster para monitorar 
```
kubectl config use-context nome_do_clusters
```
# comando para ver os pods
kubectl get pod ou kubectl get po

# criando um pod
```
apiVersion: v1
kind: Pod
metadata:
  name: "goserver"
  labels: 
    app: "goserver"
spec:
  containers:
    - name: goserver
      image: "hugollemos/demo:latest"
```
kubectl apply -f k8s/pod.yaml

# redirecionando as portas para expor
kubectl port-forward pod/goserver 80:80

# deletando um pod
kubectl delete pod goserver

# replicaseat objeto que gerencia os pods
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: demo
  labels:
    app: demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: demo
          image: hugollemos/teste:latest

```
kubectl apply -f k8s/replicaset.yaml
# objeto deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: goserver
  labels:
    app: goserver
spec:
  selector:
    matchLabels:
      app: goserver
  replicas: 2
  template:
    metadata:
    labels:
      app: "goserver"
    spec:
      containers:
        - name: goserver
          image: "hugo/demo:latest"
```
## Deployment
Deployment > ReplicaSet > Pod

## Rollout e Revisoes
kubectl rolout history deployment nome_do_deploy

kubectl rollout undo deployment nome_do_deploy
volta para a ultima versao

kubectl rollout undo deployment nome_do_deploy --to-revision
para espesificar uma versao na qual se deseja voltar.

# services
services é a porta de entrada para a aplicação, 