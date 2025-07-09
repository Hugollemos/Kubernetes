# Guia Completo do Minikube

O Minikube é uma ferramenta que permite executar Kubernetes localmente, ideal para desenvolvimento, testes e aprendizado.

## 📋 Índice

- [O que é Minikube](#o-que-é-minikube)
- [Instalação](#instalação)
- [Comandos Básicos](#comandos-básicos)
- [Configuração de Cluster](#configuração-de-cluster)
- [Addons](#addons)
- [Gerenciamento de Recursos](#gerenciamento-de-recursos)
- [Troubleshooting](#troubleshooting)

## 🎯 O que é Minikube

O Minikube é uma implementação leve do Kubernetes que:
- Cria uma VM ou container local
- Executa um cluster Kubernetes de nó único
- Suporta recursos avançados como LoadBalancer, multi-node, etc.
- É ideal para desenvolvimento local e aprendizado

## 📦 Instalação

### Linux
```bash
# Baixar binário
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Instalar
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verificar instalação
minikube version
```

### macOS
```bash
# Usando Homebrew
brew install minikube

# Ou download direto
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

### Windows
```powershell
# Usando Chocolatey
choco install minikube

# Ou Winget
winget install minikube
```

## 🚀 Comandos Básicos

### Gerenciamento do Cluster
```bash
# Iniciar cluster
minikube start

# Verificar status
minikube status

# Parar cluster
minikube stop

# Deletar cluster
minikube delete

# Reiniciar cluster
minikube stop && minikube start
```

### Configuração Avançada
```bash
# Iniciar com driver específico
minikube start --driver=docker
minikube start --driver=virtualbox
minikube start --driver=vmware

# Configurar recursos
minikube start --memory=4096 --cpus=2
minikube start --disk-size=20g

# Especificar versão do Kubernetes
minikube start --kubernetes-version=v1.28.0
```

## 🏗️ Configuração de Cluster

### Cluster Multi-Node
```bash
# Criar cluster com múltiplos nós
minikube start --nodes=4

# Adicionar nó ao cluster existente
minikube node add

# Adicionar múltiplos nós
minikube node add --worker

# Listar nós
minikube node list

# Deletar nó específico
minikube node delete <node-name>
```

### Profiles (Múltiplos Clusters)
```bash
# Criar profile específico
minikube start -p production --nodes=3

# Listar profiles
minikube profile list

# Usar profile específico
minikube profile production

# Deletar profile
minikube delete -p production
```

## 🔧 Addons

### Gerenciamento de Addons
```bash
# Listar addons disponíveis
minikube addons list

# Habilitar addon
minikube addons enable <addon-name>

# Desabilitar addon
minikube addons disable <addon-name>

# Verificar status dos addons
minikube addons list
```

### Addons Importantes
```bash
# Dashboard do Kubernetes
minikube addons enable dashboard
minikube dashboard

# Ingress Controller
minikube addons enable ingress

# Metrics Server
minikube addons enable metrics-server

# Registry (Docker Registry local)
minikube addons enable registry

# Storage Provisioner
minikube addons enable default-storageclass
minikube addons enable storage-provisioner

# DNS
minikube addons enable kube-dns
```

### Addons Específicos
```bash
# Helm
minikube addons enable helm-tiller

# Istio
minikube addons enable istio-provisioner
minikube addons enable istio

# EFK Stack (Elasticsearch, Fluentd, Kibana)
minikube addons enable efk

# Prometheus
minikube addons enable prometheus
```

## 🌐 Gerenciamento de Recursos

### Acesso a Serviços
```bash
# Obter URL de um service
minikube service <service-name>

# Obter URL sem abrir browser
minikube service <service-name> --url

# Listar URLs de todos os services
minikube service list

# Túnel para LoadBalancer services
minikube tunnel
```

### Docker Environment
```bash
# Configurar Docker para usar registry do Minikube
eval $(minikube docker-env)

# Resetar configuração do Docker
eval $(minikube docker-env -u)

# Verificar imagens no Minikube
minikube ssh -- docker images
```

### Acesso SSH
```bash
# Conectar via SSH ao nó
minikube ssh

# Executar comando via SSH
minikube ssh -- <comando>

# Copiar arquivos
minikube cp <local-file> <minikube-path>
```

## 📊 Monitoramento e Logs

### Dashboard e Monitoring
```bash
# Abrir dashboard
minikube dashboard

# Obter URL do dashboard
minikube dashboard --url

# Visualizar logs do cluster
minikube logs

# Logs de nó específico
minikube logs -n <node-name>
```

### Métricas e Performance
```bash
# Verificar recursos do cluster
kubectl top nodes
kubectl top pods

# Status detalhado
minikube status --format=json

# Informações do sistema
minikube ssh -- df -h
minikube ssh -- free -h
minikube ssh -- top
```

## 🔍 Troubleshooting

### Problemas Comuns
```bash
# Verificar logs detalhados
minikube start --alsologtostderr

# Limpar cache
minikube delete --all --purge

# Verificar configuração
minikube config view

# Diagnosticar problemas
minikube status --format=json
minikube logs --problems
```

### Configuração de Rede
```bash
# Verificar IPs
minikube ip

# Configurar proxy
minikube start --docker-env http_proxy=http://proxy:8080

# Configurar DNS
minikube start --host-dns-resolver
```

### Limpeza e Reset
```bash
# Parar todos os clusters
minikube stop --all

# Deletar todos os clusters
minikube delete --all

# Limpar cache completo
minikube delete --all --purge

# Resetar configuração
rm -rf ~/.minikube
```

## ⚙️ Configuração Avançada

### Configuração Personalizada
```bash
# Definir configurações padrão
minikube config set driver docker
minikube config set memory 4096
minikube config set cpus 2

# Visualizar configurações
minikube config view

# Remover configuração
minikube config unset <key>
```

### Integração com IDEs
```bash
# Configurar kubectl para usar Minikube
kubectl config use-context minikube

# Verificar contexto atual
kubectl config current-context

# Configurar context específico
kubectl config use-context minikube-production
```

## 📝 Exemplos Práticos

### Desenvolvimento Local
```bash
# 1. Iniciar cluster para desenvolvimento
minikube start --memory=4096 --cpus=2

# 2. Habilitar addons necessários
minikube addons enable dashboard
minikube addons enable ingress
minikube addons enable registry

# 3. Configurar Docker environment
eval $(minikube docker-env)

# 4. Deploy de aplicação
kubectl apply -f app.yaml

# 5. Acessar aplicação
minikube service app-service
```

### Teste Multi-Node
```bash
# 1. Criar cluster multi-node
minikube start --nodes=3 -p testing

# 2. Verificar nós
kubectl get nodes

# 3. Deploy com afinidade de nó
kubectl apply -f multi-node-app.yaml

# 4. Verificar distribuição
kubectl get pods -o wide
```

## 🎯 Boas Práticas

1. **Use profiles** para diferentes ambientes
2. **Configure recursos adequados** para sua máquina
3. **Habilite apenas addons necessários** para economizar recursos
4. **Use minikube tunnel** para testar LoadBalancer services
5. **Limpe clusters não utilizados** regularmente
6. **Monitore uso de recursos** da máquina host
7. **Use versões específicas** do Kubernetes para consistência

## 🚀 Próximos Passos

Após dominar o Minikube, considere:
- **Kind** (Kubernetes in Docker) para CI/CD
- **K3s** para ambientes de produção leves
- **Managed Kubernetes** (EKS, GKE, AKS) para produção
- **Kubeadm** para clusters personalizados

---

**Versão**: 2.0  
**Última atualização**: Julho 2025  
**Documentação oficial**: [Minikube](https://minikube.sigs.k8s.io/docs/)