O Container Engine é o responsável por gerenciar as imagens e volumes, é ele o responsável por garantir que os os recursos que os containers estão utilizando está devidamente isolados, a vida do container, storage, rede, etc.

## container runtime
Um container runtime é um software que executa containers e fornece serviços básicos, como gerenciamento de memória, CPU e rede.

## componentes do control plane 
etcd
kube apiserver
kube scheduler
kube controller manager
## componentes do workes 
kubelet
kube proxy

## portas TCP e UDP control plane
kube - apiserve => 6443 => tcp
etcd => 2378 - 2380 => tcp
kube - scheduler => 10251
kubelet - > 10250
kube - controller => 10252

## portas TCP e UDP workes
kube - apiserve => 6443 => tcp
etcd => 2378 - 2380 => tcp
kube - scheduler => 10251
kubelet - > 10250 => tcp
kube - controller => 10252 => tcp
nodeport => 30000 - 32767 => tcp

## pods, reclica sets, deployments e service
podes: a menor unidade, um pode ter 1 ou mais containers
Todos os containers que estiverem dentro do pod, teram o mesmo ip 
replica sets: responsavel para garantir que todas as replicadas estao ok!  

kubernetes é disponibilizado atráves de um conjunto de APIs
normalmente acessmois a api usando a CLI: kubctl
tudo é baseado em estado. voce configura o estado de cada objetio
kubernetes master
kube-apiverser
kube-controller-manager
kube-scheduler
outros nodes:
kubelet
kubeproxy


Cluster: conjunto de máquinas (Nodes)
Cada máquina possui uma quantidade de vCPU e Memória

pods":  unidade que contém os containers provisionados
o pod representa os processos dorando no clsuter
deploymenet

kubectl run nginx --image nginx --port 80
loadbanacer
kubectl port-forward svc/nginx 8080:80

kubctl create deployment hugoteste --imagem nginx --port 80 --replicas 3  
kubectl exec -ti pod -- bash
kubectl create deployment --image nginx nginx 
lubectl get deployment
kubectl get replicaset
kubectl expose deployment webserver --port 80 --target-port 80
kubectl get endpoints webserver 