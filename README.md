# Kubernetes - Guia de Estudos

Este repositório documenta meus estudos em **Kubernetes**, cobrindo desde conceitos fundamentais até implementações práticas com IaC (Infrastructure as Code) usando Terraform.

## 📋 Índice

- [Arquitetura Kubernetes](#arquitetura-kubernetes)
- [Componentes Principais](#componentes-principais)
- [Guia de Comandos](#guia-de-comandos)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Monitoramento](#monitoramento)
- [Recursos Adicionais](#recursos-adicionais)

## 🏗️ Arquitetura Kubernetes

### Control Plane (Plano de Controle)
Orquestra o cluster Kubernetes com os seguintes componentes:

- **Kube API Server**: Interface principal de comunicação com o cluster
- **etcd**: Banco de dados distribuído chave-valor para armazenar estado do cluster
- **Kube Scheduler**: Responsável pela distribuição de workloads nos nós
- **Kube Controller Manager**: Gerencia controladores do cluster
- **Cloud Controller Manager** (opcional): Integração com recursos de nuvem

### Worker Nodes (Nós de Trabalho)
Executam as aplicações e cargas de trabalho:

- **Kubelet**: Agente que garante execução dos contêineres nos pods
- **Kube Proxy**: Gerencia comunicação de rede e load balancing
- **Container Runtime**: Executa os contêineres (Docker, containerd, etc.)

## 🔧 Componentes Principais

### Pods
- Menor unidade deployável no Kubernetes
- Pode conter um ou mais contêineres
- Compartilham IP, volumes e ciclo de vida

### Deployments
- Gerencia ReplicaSets e rolling updates
- Garante número desejado de réplicas
- Facilita rollbacks e atualizações

### Services
- Expõe pods para comunicação interna e externa
- Tipos: ClusterIP, NodePort, LoadBalancer
- Atua como load balancer interno

### ConfigMaps e Secrets
- ConfigMaps: Configurações não sensíveis
- Secrets: Dados sensíveis (senhas, tokens)

## 📖 Guia de Comandos

### Gerenciamento de Cluster
```bash
# Minikube
minikube start
minikube status
minikube start --nodes 4 -p <cluster_name>
minikube stop
minikube delete

# Cluster e Nodes
kubectl get nodes
kubectl get clusters
kubectl config use-context <cluster_name>
kubectl label node <node_name> node-role.kubernetes.io/worker=worker
```

### Gerenciamento de Pods
```bash
# Visualizar pods
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide

# Criar e gerenciar pods
kubectl run <pod_name> --image=<image>
kubectl port-forward pod/<pod_name> 8080:80
kubectl delete pod <pod_name>
kubectl exec -it <pod_name> -- bash
```

### Deployments e Services
```bash
# Deployments
kubectl create deployment <name> --image=<image> --replicas=3
kubectl get deployments
kubectl rollout history deployment <name>
kubectl rollout undo deployment <name>

# Services
kubectl expose deployment <name> --port=80 --target-port=80
kubectl get services
kubectl get endpoints
```

### Debugging e Monitoramento
```bash
# Logs e eventos
kubectl logs <pod_name>
kubectl describe pod <pod_name>
kubectl get events

# Proxy para API
kubectl proxy --port=8080
```

## 📁 Estrutura do Projeto

```
├── README.md                      # Este arquivo
├── Kubernetes_Architecture/       # Documentação da arquitetura
├── Services/                      # Configurações de serviços
├── pod/                          # Manifestos de pods
├── deployment/                   # Configurações de deployments
├── replicaset/                   # Configurações de ReplicaSets
├── resources_and_HPA/            # Recursos e Horizontal Pod Autoscaler
├── statefulsets_volumes/         # StatefulSets e volumes
├── var_environment/              # Variáveis de ambiente e ConfigMaps
├── probes/                       # Health checks (liveness, readiness, startup)
├── minikube/                     # Configurações específicas do Minikube
└── iac/                          # Infrastructure as Code (Terraform)
    ├── my-eks/                   # Cluster EKS completo
    └── my-eks-existing-vpc/      # EKS com VPC existente
```

## 📊 Monitoramento

### Métricas-chave do Sistema
- **CPU**: Utilização, load average, context switches
- **Memória**: Uso, swap, buffers e cache
- **Disco**: I/O, utilização, latência
- **Rede**: Bandwidth, pacotes perdidos, erros
- **Processos**: Consumo de recursos por processo

### Ferramentas de Monitoramento
```bash
# Ferramentas integradas
top / htop          # Monitor em tempo real
vmstat              # Estatísticas de sistema
iostat              # Monitoramento de I/O
netstat             # Estatísticas de rede
free                # Uso de memória
```

## 🚀 Recursos Adicionais

### Documentação Detalhada
- [Arquitetura Kubernetes](./Kubernetes_Architecture/readme.md)
- [Configuração de Serviços](./Services/readme.md)
- [Comandos Essenciais](./comande.md)
- [Guia do Minikube](./minikube/Readme.md)
- [Infrastructure as Code](./iac/)

### Manifestos de Exemplo
- [Pods](./pod/)
- [Deployments](./deployment/)
- [Services](./Services/)
- [ConfigMaps](./var_environment/)
- [Health Checks](./probes/)

### Projetos Práticos
- [Cluster EKS Completo](./iac/my-eks/)
- [EKS com VPC Existente](./iac/my-eks-existing-vpc/)

---

**Versão**: 2.0  
**Última atualização**: Julho 2025  
**Autor**: Hugo  
**Objetivo**: Documentar aprendizado e servir como referência para Kubernetes