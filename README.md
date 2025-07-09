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
├── README.md                           # Este arquivo
├── docs/                              # Documentação completa
│   ├── architecture/                  # Arquitetura do Kubernetes
│   ├── commands-reference.md          # Referência de comandos
│   ├── kubernetes-concepts.md         # Conceitos fundamentais
│   └── minikube/                      # Guia do Minikube
├── kubernetes-resources/              # Recursos do Kubernetes organizados
│   ├── core/                          # Recursos core
│   │   └── pods/                      # Configurações de pods
│   ├── workloads/                     # Cargas de trabalho
│   │   ├── deployments/               # Deployments
│   │   ├── replicasets/               # ReplicaSets
│   │   └── statefulsets/              # StatefulSets e volumes
│   ├── networking/                    # Recursos de rede
│   │   └── services/                  # Configurações de serviços
│   ├── config/                        # Configurações
│   │   └── var_environment/           # Variáveis de ambiente e ConfigMaps
│   └── monitoring/                    # Monitoramento
│       ├── probes/                    # Health checks
│       └── hpa/                       # Horizontal Pod Autoscaler
├── infrastructure/                    # Infrastructure as Code
│   └── terraform/                     # Projetos Terraform
│       ├── my-eks/                    # Cluster EKS completo
│       └── my-eks-existing-vpc/       # EKS com VPC existente
└── examples/                          # Exemplos práticos
    └── nginx.yml                      # Exemplo de deployment nginx
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
- [Arquitetura Kubernetes](./docs/architecture/readme.md)
- [Conceitos Fundamentais](./docs/kubernetes-concepts.md)
- [Comandos Essenciais](./docs/commands-reference.md)
- [Guia do Minikube](./docs/minikube/Readme.md)
- [Infrastructure as Code](./infrastructure/terraform/)

### Recursos do Kubernetes
- [Pods](./kubernetes-resources/core/pods/)
- [Deployments](./kubernetes-resources/workloads/deployments/)
- [Services](./kubernetes-resources/networking/services/)
- [ConfigMaps](./kubernetes-resources/config/var_environment/)
- [Health Checks](./kubernetes-resources/monitoring/probes/)
- [StatefulSets](./kubernetes-resources/workloads/statefulsets/)
- [HPA](./kubernetes-resources/monitoring/hpa/)

### Projetos Práticos
- [Cluster EKS Completo](./infrastructure/terraform/my-eks/)
- [EKS com VPC Existente](./infrastructure/terraform/my-eks-existing-vpc/)

---

**Versão**: 2.0  
**Última atualização**: Julho 2025  
**Autor**: Hugo  
**Objetivo**: Documentar aprendizado e servir como referência para Kubernetes