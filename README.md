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

# LoadBalancer
```
selector:
    app: goserver
  type: LoadBalancer
  ports:
  - name: goserver-service
    port: 80
    targetPort: 8000
    protocol: TCP
```
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


