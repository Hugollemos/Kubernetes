# Kubernetes

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
kubectl rollout history deployment nome_do_deploy

kubectl rollout undo deployment nome_do_deploy

kubectl rollout undo deployment nome_do_deploy --to-revision
para espesificar uma versao na qual se deseja voltar.

# services
services é a porta de entrada para a aplicação.