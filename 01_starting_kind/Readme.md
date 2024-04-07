# Kubernetes | kind

## comandos para criar um cluster com o kind
```
kind create cluster
``` 
>depois de criado, sera apresentado um comando para acessar o cluster o cluster. <br> ex: 
```kubectl cluster-info --context kind-kind``` <br>
kind-kind é o nome do cluster
```
kind get clusters
# Mostra os clusters criado pelo kind
```
```
kind delete clusters nome_do_cluster
# Comando para deletar o cluster criado pelo kind
``` 