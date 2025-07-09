# Comandos Essenciais do Kubernetes

Este guia apresenta os comandos mais utilizados no dia a dia com Kubernetes, organizados por categoria.

## 📋 Índice

- [Gerenciamento de Cluster](#gerenciamento-de-cluster)
- [Gerenciamento de Pods](#gerenciamento-de-pods)
- [Deployments](#deployments)
- [Services](#services)
- [ConfigMaps e Secrets](#configmaps-e-secrets)
- [Namespaces](#namespaces)
- [Debugging e Troubleshooting](#debugging-e-troubleshooting)
- [Manifestos YAML](#manifestos-yaml)
- [Estratégias de Deployment](#estratégias-de-deployment)

## 🏗️ Gerenciamento de Cluster

### Visualização de Recursos
```bash
# Visualizar nós do cluster
kubectl get nodes

# Visualizar clusters configurados
kubectl config get-clusters

# Especificar cluster para monitorar
kubectl config use-context <nome_do_cluster>

# Verificar configuração atual
kubectl config current-context
```

### Configuração de Nós
```bash
# Adicionar label a um nó
kubectl label node <node_name> node-role.kubernetes.io/worker=worker

# Remover label de um nó
kubectl label node <node_name> node-role.kubernetes.io/worker-

# Visualizar labels dos nós
kubectl get nodes --show-labels
```

## 🎯 Gerenciamento de Pods

### Visualização de Pods
```bash
# Visualizar pods no namespace atual
kubectl get pods
kubectl get po  # forma abreviada

# Visualizar pods em todos os namespaces
kubectl get pods -A
kubectl get pods --all-namespaces

# Visualizar pods com informações detalhadas
kubectl get pods -o wide

# Visualizar pods em namespace específico
kubectl get pods -n <namespace>
```

### Criação e Gerenciamento de Pods
```bash
# Criar pod simples
kubectl run <nome_pod> --image=<imagem>

# Criar pod com porta específica
kubectl run <nome_pod> --image=<imagem> --port=<porta>

# Exemplo: Criar pod nginx
kubectl run nginx --image=nginx --port=80

# Deletar pod
kubectl delete pod <nome_pod>

# Executar comando em pod
kubectl exec -it <nome_pod> -- bash
```

### Port Forwarding
```bash
# Redirecionar porta para acessar pod
kubectl port-forward pod/<nome_pod> 8080:80

# Redirecionar porta para service
kubectl port-forward svc/<nome_service> 8080:80
```

## 🚀 Deployments

### Gerenciamento de Deployments
```bash
# Criar deployment
kubectl create deployment <nome> --image=<imagem> --replicas=<numero>

# Visualizar deployments
kubectl get deployments
kubectl get deploy  # forma abreviada

# Visualizar ReplicaSets
kubectl get replicaset
kubectl get rs  # forma abreviada

# Escalar deployment
kubectl scale deployment <nome> --replicas=<numero>
```

### Rollout e Versionamento
```bash
# Visualizar histórico de deployment
kubectl rollout history deployment <nome_deployment>

# Fazer rollback para versão anterior
kubectl rollout undo deployment <nome_deployment>

# Fazer rollback para versão específica
kubectl rollout undo deployment <nome_deployment> --to-revision=<numero>

# Verificar status do rollout
kubectl rollout status deployment <nome_deployment>
```

## 🌐 Services

### Gerenciamento de Services
```bash
# Expor deployment como service
kubectl expose deployment <nome_deployment> --port=<porta> --target-port=<porta_container>

# Visualizar services
kubectl get services
kubectl get svc  # forma abreviada

# Visualizar endpoints
kubectl get endpoints <nome_service>

# Deletar service
kubectl delete service <nome_service>
```

### Tipos de Service
```bash
# Service ClusterIP (padrão)
kubectl expose deployment <nome> --port=80 --type=ClusterIP

# Service NodePort
kubectl expose deployment <nome> --port=80 --type=NodePort

# Service LoadBalancer
kubectl expose deployment <nome> --port=80 --type=LoadBalancer
```

## 🔧 ConfigMaps e Secrets

### ConfigMaps
```bash
# Criar ConfigMap a partir de arquivo
kubectl create configmap <nome> --from-file=<arquivo>

# Criar ConfigMap a partir de literal
kubectl create configmap <nome> --from-literal=<chave>=<valor>

# Visualizar ConfigMaps
kubectl get configmaps
kubectl get cm  # forma abreviada

# Visualizar conteúdo do ConfigMap
kubectl describe configmap <nome>
```

### Secrets
```bash
# Criar Secret genérico
kubectl create secret generic <nome> --from-literal=<chave>=<valor>

# Visualizar secrets
kubectl get secrets

# Visualizar conteúdo do secret (base64)
kubectl get secret <nome> -o yaml
```

## 📦 Namespaces

### Gerenciamento de Namespaces
```bash
# Visualizar namespaces
kubectl get namespaces
kubectl get ns  # forma abreviada

# Criar namespace
kubectl create namespace <nome>

# Deletar namespace
kubectl delete namespace <nome>

# Definir namespace padrão
kubectl config set-context --current --namespace=<nome>
```

### Trabalhar com Namespaces
```bash
# Visualizar recursos em namespace específico
kubectl get pods -n <namespace>

# Visualizar pods do sistema
kubectl get pods -n kube-system

# Visualizar todos os recursos
kubectl get all -n <namespace>
```

## 🔍 Debugging e Troubleshooting

### Logs e Eventos
```bash
# Visualizar logs de pod
kubectl logs <nome_pod>

# Visualizar logs com follow
kubectl logs -f <nome_pod>

# Visualizar logs de container específico
kubectl logs <nome_pod> -c <nome_container>

# Visualizar eventos
kubectl get events

# Descrever recurso (detalhes e eventos)
kubectl describe pod <nome_pod>
kubectl describe service <nome_service>
kubectl describe deployment <nome_deployment>
```

### Acesso à API
```bash
# Iniciar proxy para API do Kubernetes
kubectl proxy --port=8080

# Acessar API via curl
curl http://localhost:8080/api/v1/namespaces/default/pods
```

### Utilitários
```bash
# Simular criação de recurso (dry-run)
kubectl run <nome> --image=<imagem> --dry-run=client -o yaml > manifesto.yaml

# Aplicar manifesto
kubectl apply -f manifesto.yaml

# Deletar recursos baseado em manifesto
kubectl delete -f manifesto.yaml

# Visualizar recursos múltiplos
kubectl get pods,services,deployments
```

## 📄 Manifestos YAML

### Exemplo de Pod Simples
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: exemplo-pod
  labels:
    app: exemplo
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

### Exemplo de Pod com Múltiplos Containers
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
  - name: sidecar
    image: alpine:latest
    command: ["sleep", "3600"]
```

### Exemplo de Pod com Recursos
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-com-recursos
spec:
  containers:
  - name: nginx
    image: nginx:latest
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

### Exemplo de Pod com Variáveis de Ambiente
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-com-env
spec:
  containers:
  - name: app
    image: nginx:latest
    env:
    - name: USUARIO
      value: "hugo"
    - name: IDADE
      value: "24"
    - name: AMBIENTE
      value: "producao"
```

## 🔄 Estratégias de Deployment

### Rolling Update
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: exemplo-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Máximo de pods extras durante update
      maxUnavailable: 1  # Máximo de pods indisponíveis durante update
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

### Explicação das Estratégias
- **maxSurge**: Define quantos pods extras podem ser criados durante a atualização
- **maxUnavailable**: Define quantos pods podem ficar indisponíveis durante a atualização
- **RollingUpdate**: Atualiza pods gradualmente, mantendo a disponibilidade do serviço

## 🎯 Comandos Avançados

### Visualização Avançada
```bash
# Visualizar recursos com output customizado
kubectl get pods -o json
kubectl get pods -o yaml
kubectl get pods -o wide

# Usar JSONPath para filtrar dados
kubectl get pods -o jsonpath='{.items[*].metadata.name}'

# Visualizar recursos com watch
kubectl get pods --watch

# Visualizar uso de recursos
kubectl top nodes
kubectl top pods
```

### Operações em Lote
```bash
# Aplicar todos os manifestos de um diretório
kubectl apply -f ./manifests/

# Deletar todos os pods com label específico
kubectl delete pods -l app=exemplo

# Visualizar todos os recursos
kubectl get all
```

---

**Dicas importantes:**
- Use `--dry-run=client -o yaml` para gerar manifestos automaticamente
- Sempre verifique o namespace correto com `-n <namespace>`
- Use `kubectl explain <recurso>` para entender a estrutura dos recursos
- Mantenha backups dos manifestos importantes
- Use labels para organizar e filtrar recursos

**Versão**: 2.0  
**Última atualização**: Julho 2025

