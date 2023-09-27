## container engine

Um container engine é um software que ajuda a gerenciar containers, que são pacotes de software que incluem tudo o que um aplicativo precisa para funcionar, incluindo código, bibliotecas, arquivos de configuração e dados. 

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
