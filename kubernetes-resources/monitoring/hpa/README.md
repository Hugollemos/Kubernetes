# Resources e Horizontal Pod Autoscaler (HPA)

Este diretório contém exemplos de gerenciamento de recursos e auto scaling no Kubernetes.

## 📋 Conceitos

### Resource Requests e Limits
- **Requests**: Recursos mínimos garantidos para um container
- **Limits**: Recursos máximos que um container pode usar

### Horizontal Pod Autoscaler (HPA)
Escala automaticamente o número de pods baseado em métricas como CPU, memória ou métricas customizadas.

## 📁 Arquivos neste Diretório

- `resources.yml` - Exemplo de configuração de recursos
- `hpa.yml` - Exemplo de Horizontal Pod Autoscaler

## 🔧 Configuração de Recursos

### Estrutura Básica
```yaml
resources:
  requests:
    memory: "64Mi"    # Memória garantida
    cpu: "250m"       # CPU garantida (250 miliCPUs = 0.25 CPU)
  limits:
    memory: "128Mi"   # Limite máximo de memória
    cpu: "500m"       # Limite máximo de CPU (0.5 CPU)
```

### Exemplo Completo em Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

### Exemplo em Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: webapp:latest
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
```

## 📊 Unidades de Medida

### CPU
- `1` = 1 CPU core
- `500m` = 0.5 CPU core
- `100m` = 0.1 CPU core
- `1000m` = 1 CPU core

### Memória
- `128Mi` = 128 Mebibytes
- `256M` = 256 Megabytes
- `1Gi` = 1 Gibibyte
- `1G` = 1 Gigabyte

## 🚀 Horizontal Pod Autoscaler (HPA)

### Configuração Básica
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: webapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### HPA com Múltiplas Métricas
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: advanced-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
```

## 🔧 Comandos Úteis

### Recursos
```bash
# Verificar uso de recursos por nós
kubectl top nodes

# Verificar uso de recursos por pods
kubectl top pods

# Verificar uso em namespace específico
kubectl top pods -n production

# Verificar descrição de pod com recursos
kubectl describe pod <pod-name>
```

### HPA
```bash
# Criar HPA via comando
kubectl autoscale deployment webapp --cpu-percent=50 --min=1 --max=10

# Listar HPAs
kubectl get hpa

# Descrever HPA
kubectl describe hpa webapp-hpa

# Verificar métricas do HPA
kubectl get hpa webapp-hpa --watch

# Deletar HPA
kubectl delete hpa webapp-hpa
```

## 📈 Métricas Customizadas

### HPA com Métricas Customizadas
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: custom-metrics-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "30"
```

## 🎯 Resource Quotas

### Namespace Resource Quota
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: production
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "10"
```

### Limit Ranges
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-memory-limit-range
  namespace: production
spec:
  limits:
  - default:
      cpu: "200m"
      memory: "256Mi"
    defaultRequest:
      cpu: "100m"
      memory: "128Mi"
    type: Container
```

## 📊 Quality of Service (QoS)

### Guaranteed
```yaml
# Requests = Limits
resources:
  requests:
    memory: "200Mi"
    cpu: "200m"
  limits:
    memory: "200Mi"
    cpu: "200m"
```

### Burstable
```yaml
# Requests < Limits ou apenas Requests definido
resources:
  requests:
    memory: "100Mi"
    cpu: "100m"
  limits:
    memory: "200Mi"
    cpu: "200m"
```

### BestEffort
```yaml
# Sem requests nem limits definidos
resources: {}
```

## 📝 Boas Práticas

1. **Sempre defina requests** para scheduling adequado
2. **Defina limits** para evitar consumo excessivo
3. **Monitore métricas** antes de configurar HPA
4. **Use QoS Guaranteed** para workloads críticos
5. **Teste scaling** em ambiente não produtivo
6. **Configure Resource Quotas** por namespace
7. **Use métricas customizadas** quando relevante
8. **Monitore eventos** de eviction e OOM

## 🔍 Troubleshooting

### Problemas Comuns
```bash
# Pod pending por falta de recursos
kubectl describe pod <pod-name>

# Verificar eventos de eviction
kubectl get events --field-selector reason=Evicted

# Verificar nós com pressão de recursos
kubectl describe nodes

# Verificar quotas do namespace
kubectl describe quota -n <namespace>
```

### Métricas de Debug
```bash
# Verificar se metrics-server está rodando
kubectl get deployment metrics-server -n kube-system

# Verificar se HPA consegue obter métricas
kubectl describe hpa <hpa-name>

# Logs do metrics-server
kubectl logs -n kube-system deployment/metrics-server
```

## 🎯 Exemplo Prático Completo

```yaml
# Deployment com recursos definidos
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: webapp:latest
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

---
# HPA para o deployment
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: webapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 3
  maxReplicas: 15
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

Para mais informações, consulte a [documentação principal](../README.md).