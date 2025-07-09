# Conceitos Fundamentais do Kubernetes

## Container Runtime
O Container Engine é responsável por gerenciar imagens e volumes, garantindo que os recursos utilizados pelos containers estejam devidamente isolados (vida do container, storage, rede, etc.).

**Definição**: Um container runtime é um software que executa containers e fornece serviços básicos como gerenciamento de memória, CPU e rede.

## Componentes do Control Plane
- **etcd**: Banco de dados distribuído chave-valor
- **kube-apiserver**: Interface principal de comunicação
- **kube-scheduler**: Responsável pela distribuição de workloads
- **kube-controller-manager**: Gerencia controladores do cluster

## Componentes dos Workers
- **kubelet**: Agente que garante execução dos containers nos pods
- **kube-proxy**: Gerencia comunicação de rede e load balancing

## Portas TCP - Control Plane
- **kube-apiserver**: 6443 (TCP)
- **etcd**: 2379-2380 (TCP)
- **kube-scheduler**: 10251 (TCP)
- **kube-controller-manager**: 10252 (TCP)
- **kubelet**: 10250 (TCP)

## Portas TCP - Workers
- **kube-apiserver**: 6443 (TCP)
- **kubelet**: 10250 (TCP)
- **NodePort**: 30000-32767 (TCP)

## Conceitos Principais

### Pods
- Menor unidade deployável
- Pode conter 1 ou mais containers
- Todos os containers compartilham o mesmo IP

### ReplicaSets
- Responsável por garantir que todas as réplicas estejam funcionando

### Deployments
- Gerencia ReplicaSets e rolling updates

### Services
- Expõe pods para comunicação

## Fundamentos
- Kubernetes é baseado em APIs
- Acesso via CLI: `kubectl`
- Sistema baseado em estado declarativo
- Cluster: conjunto de máquinas (nodes)
- Cada máquina possui vCPU e memória

## Comandos Básicos
```bash
# Criar pod
kubectl run nginx --image nginx --port 80

# Port forward
kubectl port-forward svc/nginx 8080:80

# Criar deployment
kubectl create deployment hugoteste --image nginx --port 80 --replicas 3

# Executar comando em pod
kubectl exec -ti pod -- bash

# Expor deployment
kubectl expose deployment webserver --port 80 --target-port 80

# Visualizar endpoints
kubectl get endpoints webserver
``` 